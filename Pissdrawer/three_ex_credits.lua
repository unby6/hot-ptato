local threeexcreds = HPTN.ease_credits
function HPTN.ease_credits(amount, instant)
    if ExtraCredit and (amount > 0) then
        threeexcreds(amount * 3, instant)
    else
        threeexcreds(amount, instant)
    end
end
