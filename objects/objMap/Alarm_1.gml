if (image_alpha > 0) {
    image_alpha -= 0.25*delta()
    alarm[1] = 1
}
else
    instance_destroy()