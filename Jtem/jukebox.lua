-- waiter waiter ! more useless features please !

require 'bit'
base64 = SMODS.load_file("JTem/base64.lua")()

---@class Jtem.MusicTag
---@field title string? Title of the music provided. Can be empty.
---@field artist string? Artist of the music provided. Can be empty.
---@field key string

JTJukebox = {}
---@type Jtem.MusicTag[]
JTJukebox.MusicTags = {}

-- Turns a 4 character long byte array in little endian into a unsigned 32 bit integer
---@param str string Byte array represented as a string
---@return number
function get_32_bit_integer_le(str)
	local l, m, n, o = string.byte(str, 1, 4)
	return l + (bit.lshift(m, 8)) + (bit.lshift(n, 16)) + (bit.lshift(o, 24))
end

-- Turns a 4 character long byte array in big endian into a unsigned 32 bit integer
---@param str string Byte array represented as a string
---@return number
function get_32_bit_integer_be(str)
	local l, m, n, o = string.byte(str, 1, 4)
	return (bit.lshift(l, 24)) + (bit.lshift(m, 16)) + (bit.lshift(n, 8)) + o
end

-- Decodes a base64 image from a vorbis comment
---@param str string Base64 string to decode
---@param name string Atlas name identifier
function decode_vorbis_comment_img(str, name)
	local decoded = base64.decode(str)
	local idx = 1

	--NFS.write(HotPotato.path .. name .. "_og.jpg", decoded)

	-- https://www.rfc-editor.org/rfc/rfc9639.html#name-picture
	-- note: most of these are unused, but might be important later idk
	-- image type according to table 13
	local type = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4

	-- mime type
	local type_len = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4
	local mime_type = string.sub(decoded, idx, idx + type_len - 1); idx = idx + type_len

	-- optional description
	local desc_len = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4
	local desc = string.sub(decoded, idx, idx + desc_len - 1); idx = idx + desc_len

	-- image properties
	local width = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4
	local height = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4
	local color_depth = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4
	local num_colors = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4
	local len = get_32_bit_integer_be(string.sub(decoded, idx, idx + 4)); idx = idx + 4

	-- actual image data
	NFS.write(HotPotato.path .. name .. ".jpg", string.sub(decoded, idx, idx + len - 1))
	local byte_data = NFS.newFileData(HotPotato.path .. name .. ".jpg")
	local img_data = love.image.newImageData(byte_data)
	NFS.remove(HotPotato.path .. name .. ".jpg")

	-- meant to be fed into G.ASSET_ATLAS
	return {
		path = "",
		full_path = "",
		image_data = img_data,
		px = img_data:getWidth(),
		py = img_data:getHeight(),
		image = love.graphics.newImage(img_data),
		type = "",
		name = name
	}
end

-- Creates a MusicTag from a desired path. Also creates its respective cover image if applicable.
---@param path string Path to the music file.
---@param music_name string Identifier for the MusicTag.
---@return Jtem.MusicTag
function JTJukebox.read_music_tags(path, music_name)
	local data = NFS.read('data', path)
	if not data then return {} end
	local str = data:getString() -- byte arrays aren't a thing in lua :P
	-- find first 'vorbis' string. determines if its actually a vorbis file
	local idx = string.find(str, 'vorbis')
	---@type Jtem.MusicTag
	local info = { key = music_name }
	if idx > 0 then
		-- find second vorbis string
		local v = string.find(str, 'vorbis', idx + 6)
		if not v then return info end
		idx = v + 6
		-- Skip over vendor_string
		local vendor_length = get_32_bit_integer_le(string.sub(str, idx, idx + 4))
		idx = idx + vendor_length + 4
		-- get comment size
		local comment_size = get_32_bit_integer_le(string.sub(str, idx, idx + 4))
		idx = idx + 4
		-- get every comment based on comment size
		for i = 1, comment_size do
			-- comment length
			local len = get_32_bit_integer_le(string.sub(str, idx, idx + 4))
			idx = idx + 4
			local comment = string.sub(str, idx, idx + len - 1)
			-- split string between =
			local tag_values = {}
			local count = 0
			for c in string.gmatch(comment, '([^=]+)') do
				if count == 0 then
					tag_values[1] = c
				else
					tag_values[2] = (tag_values[2] or "") .. c
				end
				count = count + 1
			end
			local comment_name = string.lower(tag_values[1])
			-- This is an image. Do not add to final info as it is unnecessary
			if comment_name == "metadata_block_picture" then
				tag_values[2] = tag_values[2] .. "=="
				G.ASSET_ATLAS[(music_name or path)] = decode_vorbis_comment_img(tag_values[2], music_name)
			else
				-- add it to our info
				info[string.lower(tag_values[1])] = tag_values[2]
			end
			-- change index based on length
			idx = idx + len
		end
	end
	print("Injected music " .. music_name .. " for the Jukebox!")
	info.key = music_name
	return info
end

-- Inject this when creating a new music sound
local old_inject = SMODS.Sound.inject
SMODS.Sound.inject = function(self, i)
	old_inject(self, i)
	-- for now only filter hot potato's music tracks
	if string.find(self.key, "music_") and self.mod == HotPotato then
		_, JTJukebox.MusicTags[#JTJukebox.MusicTags + 1] = pcall(JTJukebox.read_music_tags, self.full_path, self.key)
		JTJukebox.Current = 3
	end
end

-- Taken from Stacked thanks bepis
JTJukebox.manual_parse = function(text, args)
	if not text then return end
	if type(text) ~= "table" then text = { text } end
	local args = args or {}
	local dir = G.localization
	if args.loc_dir then
		for _, v in ipairs(args.loc_dir) do
			dir[v] = dir[v] or {}
			dir = dir[v]
		end
	else
		dir = G.localization.misc.v_text_parsed
	end
	local key = args.loc_key or "SMODS_stylize_text"
	local function deep_find(t, index)
		if type(index) ~= "table" then index = { index } end
		for _, idv_index in ipairs(index) do
			if t[idv_index] then return true end
			for i, v in pairs(t) do
				if i == idv_index then return true end
				if type(v) == "table" then
					return deep_find(v, idv_index)
				end
			end
		end
		return false
	end
	if deep_find(text, "control") then
		if not args.no_loc_save then dir = text end
		return text
	end

	local a = { "text", "name", "unlock" }
	if not args.no_loc_save then
		local loc = dir
		loc[key] = {}
		if deep_find(text, a) then
			for _, v in ipairs(a) do
				text[v] = text[v] or {}
				text[v .. "_parsed"] = text[v .. "_parsed"] or {}
			end
			if text.text then
				for _, v in ipairs(text.text) do
					if type(v) == "table" then
						text.text_parsed[#text.text_parsed + 1] = {}
						for _, vv in ipairs(v) do
							text.text_parsed[#text.text_parsed][#text.text_parsed[#text.text_parsed] + 1] =
								loc_parse_string(vv)
						end
					else
						text.text_parsed[#text.text_parsed + 1] = loc_parse_string(v)
					end
				end
			end
			if text.name then
				for _, v in ipairs((type(text.name) == "string" and { text.name }) or text.name) do
					text.name_parsed[#text.name_parsed + 1] = loc_parse_string(v)
				end
			end
			if text.unlock then
				for _, v in ipairs(text.unlock) do
					text.unlock_parsed[#text.unlock_parsed + 1] = loc_parse_string(v)
				end
			end
			loc[key] = text
		else
			for i, v in ipairs(text) do
				loc[key][i] = loc_parse_string(v)
			end
		end

		return loc[key]
	else
		local loc = {}
		if deep_find(text, a) then
			for _, v in ipairs(a) do
				text[v] = text[v] or {}
				text[v .. "_parsed"] = text[v .. "_parsed"] or {}
			end
			if text.text then
				for _, v in ipairs(text.text) do
					if type(v) == "table" then
						text.text_parsed[#text.text_parsed + 1] = {}
						for _, vv in ipairs(v) do
							text.text_parsed[#text.text_parsed][#text.text_parsed[#text.text_parsed] + 1] =
								loc_parse_string(vv)
						end
					else
						text.text_parsed[#text.text_parsed + 1] = loc_parse_string(v)
					end
				end
			end
			if text.name then
				for _, v in ipairs((type(text.name) == "string" and { text.name }) or text.name) do
					text.name_parsed[#text.name_parsed + 1] = loc_parse_string(v)
				end
			end
			if text.unlock then
				for _, v in ipairs(text.unlock) do
					text.unlock_parsed[#text.unlock_parsed + 1] = loc_parse_string(v)
				end
			end
			loc = text
		else
			for i, v in ipairs(text) do
				loc[i] = loc_parse_string(v)
			end
		end

		return loc
	end
end

-- Creates a description from a MusicTag.
---@param current Jtem.MusicTag The MusicTag to use.
---@return balatro.Loc.ParsedEntry|{ [number]: balatro.Loc.Parsed[] |nil}
function JTJukebox.CreateDescription(current)
	return JTJukebox.manual_parse(
		{
			"{s:1.1}" .. (current.title or current.key),
			"{C:dark_edition}" .. (current.artist or "")
		},
		{ loc_key = current.key }
	)
end

function G.FUNCS.hpot_jukebox_go_back(e)
	JTJukebox.Current = JTJukebox.Current - 1
	if JTJukebox.Current <= 0 then JTJukebox.Current = #JTJukebox.MusicTags end
	JTJukebox.CurrentDesc = JTJukebox.CreateDescription(JTJukebox.MusicTags[JTJukebox.Current])
end

function G.FUNCS.hpot_jukebox_go_next(e)
	JTJukebox.Current = JTJukebox.Current + 1
	if JTJukebox.Current > #JTJukebox.MusicTags then JTJukebox.Current = 1 end
	JTJukebox.CurrentDesc = JTJukebox.CreateDescription(JTJukebox.MusicTags[JTJukebox.Current])
end

function G.FUNCS.hpot_update_current(e)
	if JTJukebox.LastCurrentDesc ~= JTJukebox.CurrentDesc then
		JTJukebox.LastCurrentDesc = JTJukebox.CurrentDesc
		local current = JTJukebox.MusicTags[JTJukebox.Current]

		-- get song info element
		---@type balatro.UIElement
		local song_info = e.UIBox:get_UIE_by_ID('hpot_jukebox_songinfo')
		-- clear all children
		song_info.children = {}

		local final_line = {}
		for _, line in ipairs(JTJukebox.CurrentDesc) do
			final_line[#final_line + 1] = {
				n = G.UIT.R,
				config = { align = "cm", padding = 0.06 },
				nodes = SMODS
					.localize_box(line, {})
			}
		end

		-- create a new uibox for the song info description
		song_info.children[#song_info.children + 1] = UIBox {
			definition = {
				n = G.UIT.C,
				config = { align = "cm", minh = 1, minw = 4, colour = G.C.WHITE, r = 0.2, emboss = 0.05 },
				nodes = final_line,
			}, config = { parent = song_info, align = "cm", major = song_info }
		}
		e.UIBox:recalculate()

		-- update cover art
		local cover = e.UIBox:get_UIE_by_ID('hpot_jukebox_cover_art')
		cover.config.object.atlas = G.ASSET_ATLAS[current.key] or G.ASSET_ATLAS["hpot_jukebox_default"]
	end
end

---@param config table
---@return table
function create_center_aligned_text(config)
	return {
		n = G.UIT.R,
		config = { align = "cm", r = 0.2, maxw = config.maxw or 1e300 },
		nodes = {
			{
				n = G.UIT.T,
				config = config
			}
		}
	}
end

function G.FUNCS.hpot_jukebox_play(e)
	local current = JTJukebox.MusicTags[JTJukebox.Current]
	if not JTJukebox.ActuallyPlaying then
		JTJukebox.CurrentlyPlaying = (current.title and (current.title .. " - " .. current.artist) or current.key)
		JTJukebox.ActuallyPlaying = current.key
		e.children[1].children[1].config.text = localize('hotpot_jukebox_unrequest')
	else
		JTJukebox.CurrentlyPlaying = localize('hotpot_jukebox_default_music_title')
		JTJukebox.ActuallyPlaying = nil
		e.children[1].children[1].config.text = localize('hotpot_jukebox_request')
	end
	local jukebox_text = e.UIBox:get_UIE_by_ID('hpot_jukebox_text')
	jukebox_text.config.object:update_text(true)
	e.UIBox:recalculate()
end

-- Jukebox tab lmao
function JTJukebox.MusicTab()
	JTJukebox.CurrentDesc = JTJukebox.CreateDescription(JTJukebox.MusicTags[JTJukebox.Current])
	local current = JTJukebox.MusicTags[JTJukebox.Current]
	JTJukebox.CurrentlyPlaying = JTJukebox.CurrentlyPlaying or localize('hotpot_jukebox_default_music_title')
	local titleDynaText = DynaText {
		string = {
			{
				ref_table = JTJukebox,
				ref_value = "CurrentlyPlaying"
			}
		},
		colours = { G.C.DARK_EDITION },
		bump = false,
		silent = true,
		pop_in_rate = 99999,
		spacing = 2,
		maxw = 7.25,
		does_scroll = true,
		non_recalc = true,
		shadow = true,
	}
	titleDynaText.config.stencil = function()
		love.graphics.rectangle(
			"fill",
			titleDynaText.T.x * G.TILESIZE * G.TILESCALE,
			titleDynaText.T.y * G.TILESIZE * G.TILESCALE,
			7.25 * G.TILESIZE * G.TILESCALE,
			10 * G.TILESIZE * G.TILESCALE
		)
	end
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = {
					r = 0.1,
					minw = 8,
					minh = 6,
					align = "tm",
					padding = 0.2,
					colour = G.C.BLACK
				},
				nodes = {
					{
						n = G.UIT.C,
						config = {
							r = 0.1,
							minw = 7.75,
							minh = 5.5,
							align = "tm",
							padding = 0.2,
							colour = G.C.CLEAR
						},
						nodes = {
							-- Banner
							{
								n = G.UIT.R,
								config = {
									r = 0.1,
									minw = 7.75,
									minh = 1,
									align = "cm",
									padding = 0.2,
									colour = darken(G.C.BLACK, 0.2),
									emboss = 0.05,
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = titleDynaText,
											id = 'hpot_jukebox_text'
										}
									},
								}
							},
							-- Cover art (if any)
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									padding = 0.2,
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = Sprite(
												0, 0, 4, 4,
												G.ASSET_ATLAS[current.key] or G.ASSET_ATLAS["hpot_jukebox_default"],
												{ x = 0, y = 0 }
											),
											id = 'hpot_jukebox_cover_art'
										},
									}
								}
							},
							-- Current info
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									padding = 0.2,
									func = 'hpot_update_current'
								},
								nodes = {
									-- current song info
									{
										n = G.UIT.C,
										config = { id = 'hpot_jukebox_songinfo', padding = 0.2, align = "cm" },
										nodes = {},
									},
								}
							},
							-- Playback controls
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									padding = 0.2,
								},
								nodes = {
									-- go back
									{
										n = G.UIT.C,
										config = { align = "cm", minh = 0.8, minw = 0.8, colour = G.C.RED, r = 0.2, emboss = 0.05, button = 'hpot_jukebox_go_back' },
										nodes = {
											create_center_aligned_text { align = "cm", text = "<", colour = G.C.UI.TEXT_LIGHT, maxw = 0.7, scale = 0.75, shadow = true }
										}
									},
									-- play butan
									{
										n = G.UIT.C,
										config = { align = "cm", minh = 0.8, minw = 4, colour = G.C.GREEN, r = 0.2, emboss = 0.05, button = 'hpot_jukebox_play' },
										nodes = {
											create_center_aligned_text { align = "cm", text = localize('hotpot_jukebox_' .. (JTJukebox.ActuallyPlaying and 'un' or '') .. 'request'), colour = G.C.UI.TEXT_LIGHT, maxw = 3.5, scale = 0.5, shadow = true }
										},
									},
									-- go next
									{
										n = G.UIT.C,
										config = { align = "cm", minh = 0.8, minw = 0.8, colour = G.C.RED, r = 0.2, emboss = 0.05, button = 'hpot_jukebox_go_next' },
										nodes = {
											create_center_aligned_text { align = "cm", text = ">", colour = G.C.UI.TEXT_LIGHT, maxw = 0.7, scale = 0.75, shadow = true }
										}
									},
								}
							},
						}
					}
				}
			}
		}
	}
end
