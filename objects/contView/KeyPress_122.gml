if (!fullscreenLock and room != roomFPS and os_type == os_windows) {
	alarm[1] = 1
	
	fullscreenLock = true
	alarm[6] = sec/2
	
    if (instance_exists(contLight)) {
        free_surface(contLight.sl_buffer_surface1)
        free_surface(contLight.sl_buffer_surface2)
    }
	
	free_all_surfaces()

	if (!instance_exists(objMainMenuDraw)) {
		with(contGUi) {
			colorScreenAlpha = 1
			alarm[1] = 1
		}
	} else {
		with (objMainMenuDraw) {
			blackScreenAlpha = 1
			alarm[1] = 1
		}
	}
}