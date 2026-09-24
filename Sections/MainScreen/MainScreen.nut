fe.do_nut("Sections/MainScreen/GameList/GameList.nut")
fe.do_nut("Sections/MainScreen/RightBox/RightBox.nut")

class MainScreen {
    isActive = true

    gameList = null
    rightBox = null

    constructor() {
        this.rightBox = RightBox()
        this.gameList = GameList()
    }

    function key_detect(signal_str) {
        if (this.gameList.key_detect(signal_str)) {
            return true
        }

        if (this.rightBox.key_detect(signal_str)) {
            return true
        }

        switch (signal_str) {
            case "left":
                ::sound_engine.play_click_sound()
                this.gameList.activate()
                this.rightBox.desactivate()
                return true
                break

            case "right":
                ::sound_engine.play_click_sound()
                this.rightBox.activate()
                this.gameList.desactivate()
                return true
                break
        }
    }
}
