SMODS.Atlas {
    key = "jtem_imagine",
    path = "Jtem/imagine.png",
    px=71, py=95
}

SMODS.ConsumableType {
    key = "imaginary",
    primary_colour = HEX("9ec7cf"),
    secondary_colour = HEX("feff5b"),
    collection_row = {5, 5},
    shop_rate = 1,
    default = "c_hpot_imag_stars",
    text_colour = HEX("333333"),
}

SMODS.Consumable{
    key = "imag_stars",
    set = "imaginary",
    atlas = "jtem_imagine",
    pos = {x=1,y=0}
}