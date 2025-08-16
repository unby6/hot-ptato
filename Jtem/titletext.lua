-- please add more to this if you think of any im out of ideas

HPJTTT = {
    chosen = 1,
    text = {
        "Also try Nubbys Number Factory!",
        "HotPot Edition",
        "Joker Poker",
        "The Original                                      Rougelike",
        "18+",
        "Plant Vs Faces",
        "how LOVELY",
        "guess you're really feeling the BALATRO",
        "Hey folks! In today's video we're back with another unseeded high score Balatro run. Here, after running a lot of Baron/Mime builds recently, I decided to work towards an Idol after receiving a lot of Queens and several Immolates in the early game. The result was one of the best Flush Five builds I've ever put together. Enjoy the video! ",
        "Ship It",
        "Go Next"
    }
}



HPJTTT.chosen = (math.floor(os.time())%#HPJTTT.text)+1

HPJTTT.balala = (math.floor(os.time())%100) == 0