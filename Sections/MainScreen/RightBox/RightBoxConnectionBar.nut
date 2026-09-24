class RightBoxConnectionBar {
    vbar = null
    hbar = null
    surface = null

    constructor() {
        this.surface = fe.add_surface(260, 340, 200, 190)

        this.hbar = this.surface.add_rectangle(0, 65, 200, 15)
        this.hbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2])

        this.vbar = this.surface.add_rectangle(190, 5, 20, 180)
        this.vbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2])
        this.vbar.corner_radius = 10
    }

    function activate() {
        this.vbar.set_rgb(COLOR.accent_two[0], COLOR.accent_two[1], COLOR.accent_two[2])
        this.hbar.set_rgb(COLOR.accent_two[0], COLOR.accent_two[1], COLOR.accent_two[2])
    }

    function desactivate() {
        this.vbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2])
        this.hbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2])
    }

    function move_to(position) {
        this.surface.y = 240 + position * 130
    }
}
