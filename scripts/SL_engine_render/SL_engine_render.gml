function SL_engine_render() {
	/* SL_engine_render();                       */
	/* Calcule l'ensemble des ombres et lumières */

	if (global.lightActive) {
		var cam = global.camera
		var i, i1, r, g, b, j, sl, rl;

		if !surface_exists(sl_buffer_surface1)
		{
		    sl_buffer_surface1 = create_surface((camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize);
		    sl_buffer_surface2 = create_surface((camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize);
			sl_buffer_width    = surface_get_width (sl_buffer_surface1);
		    sl_buffer_height   = surface_get_height(sl_buffer_surface1);
		}

	#region DELETED
		/// - GESTION DU TOD/HEURE

		// Gestion de l'avancement de l'heure
		// ? was original
		/*global.sl_time += sl_timespeed;
		if global.sl_time >= 24 { global.sl_time=0 sl_tod_index=1 };
		if global.sl_time >= sl_tod[sl_tod_index+1,0] sl_tod_index += 1;*/

		// Calcul de la puissance de l'éclairage ambiant
		// ? was original
		/*
		if sl_tod_active global.sl_ambient_light = ((global.sl_time-sl_tod[sl_tod_index,0])/(sl_tod[sl_tod_index+1,0]-sl_tod[sl_tod_index,0]))*(sl_tod[sl_tod_index+1,4]-sl_tod[sl_tod_index,4])+sl_tod[sl_tod_index,4];*/
	#endregion

		/// - MASKS
		draw_set_alpha(1);
		gpu_set_blendmode(bm_normal);

		for (i1=0; i1<sl_layers_count; i1+=1)
		{
		    if !surface_exists(sl_layers_surface[i1]) sl_layers_surface[i1] = create_surface((camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize);
    
		    surface_set_target(sl_layers_surface[i1]); // Création des masks pour le rendu des layers
		    draw_clear(c_white);
    
		    for (i2=0; sl_global_list[i2,1]!=-1; i2+=1) if sl_global_list[i2,0]=i1 with sl_global_list[i2,1] if visible
		     draw_sprite_ext(sprite_index,floor(image_index),(x-camera_get_view_x(cam)+other.sl_buffer_xmargin)*other.sl_buffer_texturesize,(y-camera_get_view_y(cam)+other.sl_buffer_ymargin)*other.sl_buffer_texturesize,image_xscale*other.sl_buffer_texturesize,image_yscale*other.sl_buffer_texturesize,image_angle,c_black,image_alpha);
		    for (i2=0; global.sl_earthlist[i2,0]!=-1; i2+=1) if global.sl_earthlist[i2,0]=i1
		     draw_sprite_ext(global.sl_earthlist[i2,4],global.sl_earthlist[i2,5],(global.sl_earthlist[i2,6]-camera_get_view_x(cam)+sl_buffer_xmargin)*sl_buffer_texturesize,(global.sl_earthlist[i2,7]-camera_get_view_y(cam)+sl_buffer_ymargin)*sl_buffer_texturesize,global.sl_earthlist[i2,9]*sl_buffer_texturesize,global.sl_earthlist[i2,10]*sl_buffer_texturesize,global.sl_earthlist[i2,11],c_black,global.sl_earthlist[i2,12]);
    
		    gpu_set_blendmode_ext(bm_inv_dest_color,bm_inv_src_color);
		    draw_set_color(c_white);
		    draw_rectangle(0,0,(camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize,0);
    
		    gpu_set_blendmode_ext(bm_src_color,bm_one);
		    draw_set_color(c_black);
		    draw_rectangle(0,0,(camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize,0);
		    draw_set_color(c_white);
		    gpu_set_blendmode(bm_normal);
		    surface_reset_target();
		}

	#region DELETED
		/// - OMBRES SOLAIRES

		// ? was original
		/*if sl_sunshadows_active{

		sl_sunshadows_refreshcounter-=1;

		if sl_sunshadows_refresh && sl_sunshadows_refreshcounter<=0
		{
		    // Calcul des composantes des ombres solaires
		    if sl_tod_active
		    {sl_sunshadows_direction = ((global.sl_time-sl_tod[sl_tod_index,0])/(sl_tod[sl_tod_index+1,0]-sl_tod[sl_tod_index,0]))*(sl_tod[sl_tod_index+1,5]-sl_tod[sl_tod_index,5])+sl_tod[sl_tod_index,5];
		     sl_sunshadows_length    = ((global.sl_time-sl_tod[sl_tod_index,0])/(sl_tod[sl_tod_index+1,0]-sl_tod[sl_tod_index,0]))*(sl_tod[sl_tod_index+1,6]-sl_tod[sl_tod_index,6])+sl_tod[sl_tod_index,6]};
		    sl_sunshadows_light      = -(sl_sunshadows_alpha/(1-sl_sunshadows_alphalimit)*(global.sl_ambient_light-sl_sunshadows_alphalimit))+1;
    
		    if sl_sunshadows_light < 1
		    {
		        if !surface_exists(sl_sunshadows_surface2)
		        {
		            sl_sunshadows_surface1[0] = create_surface((camera_get_view_width(global.camera)+sl_sunshadows_margin*2)*sl_sunshadows_texturesize,(camera_get_view_height(global.camera)+sl_sunshadows_margin*2)*sl_sunshadows_texturesize);
		            sl_sunshadows_surface1[1] = create_surface((camera_get_view_width(global.camera)+sl_sunshadows_margin*2)*sl_sunshadows_texturesize,(camera_get_view_height(global.camera)+sl_sunshadows_margin*2)*sl_sunshadows_texturesize);
		            sl_sunshadows_surface2    = create_surface((camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize);
		        }
        
		        for (i1=0; i1<sl_layers_count; i1+=1)
		        {
		            surface_set_target(sl_sunshadows_surface1[0]); // Création du sample
		            draw_clear(c_white);
            
		            sl_r = 0;
            
		            for (i2=0; sl_sunshadows_list[i2,1]!=-1; i2+=1) if sl_sunshadows_list[i2,0] = i1
		            {
		                sl_xx = lengthdir_x(1+global.sl_z[sl_sunshadows_list[i2,1]]*sl_sunshadows_length,sl_sunshadows_direction)-camera_get_view_x(cam)+sl_sunshadows_margin;
		                sl_yy = lengthdir_y(1+global.sl_z[sl_sunshadows_list[i2,1]]*sl_sunshadows_length,sl_sunshadows_direction)-camera_get_view_y(cam)+sl_sunshadows_margin;
                
		                with sl_sunshadows_list[i2,1] if visible
		                {
		                    other.sl_r = 1;
		                    var shspr;
		                    if other.sl_sunshadows_list[other.i2,2]>-1 shspr = other.sl_sunshadows_list[other.i2,2] else shspr = sprite_index;
                    
		                    draw_sprite_ext(shspr,floor(image_index),(x+other.sl_xx)*other.sl_sunshadows_texturesize,(y+other.sl_yy)*other.sl_sunshadows_texturesize,image_xscale*other.sl_sunshadows_texturesize,image_yscale*other.sl_sunshadows_texturesize,image_angle,c_black,image_alpha);
		                }
		            }
            
		            for (i2=0; global.sl_earthlist[i2,0]!=-1; i2+=1) if global.sl_earthlist[i2,0]=i1 && global.sl_earthlist[i2,1]=true
		            {
		                sl_r  = 1;
		                sl_xx = lengthdir_x(1+global.sl_earthlist[i2,8]*sl_sunshadows_length,sl_sunshadows_direction)-camera_get_view_x(cam)+sl_sunshadows_margin;
		                sl_yy = lengthdir_y(1+global.sl_earthlist[i2,8]*sl_sunshadows_length,sl_sunshadows_direction)-camera_get_view_y(cam)+sl_sunshadows_margin;
                
		                draw_sprite_ext(global.sl_earthlist[i2,4],global.sl_earthlist[i2,5],(global.sl_earthlist[i2,6]+sl_xx)*sl_sunshadows_texturesize,(global.sl_earthlist[i2,7]+sl_yy)*sl_sunshadows_texturesize,global.sl_earthlist[i2,9]*sl_sunshadows_texturesize,global.sl_earthlist[i2,10]*sl_sunshadows_texturesize,global.sl_earthlist[i2,11],c_black,global.sl_earthlist[i2,12]);
		            }
            
		            surface_reset_target();
            
		            surface_set_target(sl_sunshadows_surface1[1]); // Projection des ombres
		            draw_clear(c_white);
		            gpu_set_blendmode_ext(bm_dest_color,bm_zero);
            
		            i = 1;
            
		            if sl_r && sl_sunshadows_length != 0
		            {
		                j  = ((sl_sunshadows_length*sl_sunshadows_layerscale[i1]) / (sl_sunshadows_length*sl_sunshadows_layerscale[i1]*sl_sunshadows_quality)) * sl_sunshadows_texturesize;
		                sl = sl_sunshadows_length * sl_sunshadows_layerscale[i1] * sl_sunshadows_texturesize;
		                rl = j / 2;
		                b  = 0;

		                repeat (ceil(sqr(sl/j)))
		                {
		                    surface_reset_target();
		                    surface_set_target(sl_sunshadows_surface1[i]);
		                    rl *= 2;  if rl*2-j >= sl {rl = sl-rl+j  b = 1};
		                    draw_clear(c_white);
		                    draw_surface(sl_sunshadows_surface1[!i],0,0); //0,0
		                    if b break;
		                    draw_surface(sl_sunshadows_surface1[!i],lengthdir_x(rl,sl_sunshadows_direction),lengthdir_y(rl,sl_sunshadows_direction)); 
		                    i = !i;
		                }
		            }
		            surface_reset_target();
            
		            surface_set_target(sl_sunshadows_surface2); // Composition finale des ombres
		            if i1 = 0 draw_clear(c_white);
            
		            if sl_r && sl_sunshadows_length != 0
		            {
		                sl_xx = lengthdir_x(rl/sl_sunshadows_texturesize,sl_sunshadows_direction);
		                sl_yy = lengthdir_y(rl/sl_sunshadows_texturesize,sl_sunshadows_direction);
                
		                draw_surface_ext(sl_sunshadows_surface1[i],(-sl_sunshadows_margin+sl_buffer_xmargin)*sl_buffer_texturesize,(-sl_sunshadows_margin+sl_buffer_ymargin)*sl_buffer_texturesize,1/sl_sunshadows_texturesize*sl_buffer_texturesize,1/sl_sunshadows_texturesize*sl_buffer_texturesize,0,c_white,1);
		                draw_surface_ext(sl_sunshadows_surface1[i],(-sl_sunshadows_margin+sl_buffer_xmargin+sl_xx)*sl_buffer_texturesize,(-sl_sunshadows_margin+sl_buffer_ymargin+sl_yy)*sl_buffer_texturesize,1/sl_sunshadows_texturesize*sl_buffer_texturesize,1/sl_sunshadows_texturesize*sl_buffer_texturesize,0,c_white,1);
		            }
            
		            gpu_set_blendmode(bm_normal);
		            for (i2=0; sl_sunshadows_texlist[i2,1]!=-1; i2+=1) if sl_sunshadows_texlist[i2,0] = i1
		            {
		                sl_xx = lengthdir_x(global.sl_z[sl_sunshadows_texlist[i2,1]]*sl_sunshadows_length,sl_sunshadows_direction)-camera_get_view_x(cam)+sl_buffer_xmargin;
		                sl_yy = lengthdir_y(global.sl_z[sl_sunshadows_texlist[i2,1]]*sl_sunshadows_length,sl_sunshadows_direction)-camera_get_view_y(cam)+sl_buffer_ymargin;
		                sl_xs = (1+(sl_sunshadows_length*sl_sunshadows_layerscale[sl_sunshadows_texlist[i2,0]])/sl_sunshadows_texlist[i2,3])*sl_buffer_texturesize;
                
		                with sl_sunshadows_texlist[i2,1] draw_sprite_ext(other.sl_sunshadows_texlist[other.i2,2],0,(x+other.sl_xx)*other.sl_buffer_texturesize,(y+other.sl_yy)*other.sl_buffer_texturesize,image_xscale*other.sl_xs,image_yscale*other.sl_buffer_texturesize,other.sl_sunshadows_direction,c_black,image_alpha);
		            }
		            for (i2=0; global.sl_texlist_shad[i2,0]!=-1; i2+=1) if global.sl_texlist_shad[i2,0] = i1
		            draw_sprite_ext(global.sl_texlist_shad[i2,1],global.sl_texlist_shad[i2,2],(global.sl_texlist_shad[i2,3]-camera_get_view_x(cam)+sl_buffer_xmargin)*sl_buffer_texturesize,(global.sl_texlist_shad[i2,4]-camera_get_view_y(cam)+sl_buffer_ymargin)*sl_buffer_texturesize,global.sl_texlist_shad[i2,5]*sl_buffer_texturesize,global.sl_texlist_shad[i2,6]*sl_buffer_texturesize,global.sl_texlist_shad[i2,7],c_black,global.sl_texlist_shad[i2,8]);
            
		            gpu_set_blendmode(bm_one);
		            draw_surface(sl_layers_surface[i1],0,0);
		            gpu_set_blendmode(bm_normal);
            
		            if i1+1 = sl_layers_count
		            {
		                draw_set_alpha(sl_sunshadows_light);
		                draw_rectangle_color(0,0,(camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize,c_white,c_white,c_white,c_white,0);
		                draw_set_alpha(1);
		            }
		            surface_reset_target();
		        }
		    }
		}

		if sl_sunshadows_refreshcounter<=0 sl_sunshadows_refreshcounter = sl_sunshadows_refreshrate;
		global.sl_texlist_shad[0,0]  = -1;
		global.sl_texlist_shad_index = 0};*/
	#endregion

	#region DELETED
		/// - OMBRES AMBIANTES
		// ? was original
		/*
		if sl_ambientshadows_active if !sl_ambientshadows_lock
		{
		    if !surface_exists(sl_ambientshadows_surface) sl_ambientshadows_surface = create_surface((camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize);
    
		    surface_set_target(sl_ambientshadows_surface);
		    draw_clear(c_white);
    
		    for (i1=0; i1<sl_layers_count; i1+=1)
		    {
		        gpu_set_blendmode(bm_normal);
        
		        for (i2=0; sl_ambientshadows_list[i2,1]!=-1; i2+=1) if sl_ambientshadows_list[i2,0]=i1 with sl_ambientshadows_list[i2,1] if visible
		         draw_sprite_ext(other.sl_ambientshadows_map[sprite_index],floor(image_index),(x-camera_get_view_x(cam)+other.sl_buffer_xmargin)*other.sl_buffer_texturesize,(y-camera_get_view_y(cam)+other.sl_buffer_ymargin)*other.sl_buffer_texturesize,(image_xscale/other.sl_ambientshadows_mapscale)*other.sl_buffer_texturesize,(image_yscale/other.sl_ambientshadows_mapscale)*other.sl_buffer_texturesize,image_angle,c_white,1);  
		        for (i2=0; global.sl_earthlist[i2,0]!=-1; i2+=1) if global.sl_earthlist[i2,0]=i1  && global.sl_earthlist[i2,2]=true
		         draw_sprite_ext(sl_ambientshadows_map[global.sl_earthlist[i2,4]],global.sl_earthlist[i2,5],(global.sl_earthlist[i2,6]-camera_get_view_x(cam)+sl_buffer_xmargin)*sl_buffer_texturesize,(global.sl_earthlist[i2,7]-camera_get_view_y(cam)+sl_buffer_xmargin)*sl_buffer_texturesize,(global.sl_earthlist[i2,9]/sl_ambientshadows_mapscale)*sl_buffer_texturesize,(global.sl_earthlist[i2,9]/sl_ambientshadows_mapscale)*sl_buffer_texturesize,global.sl_earthlist[i2,11],c_white,1);
        
		        gpu_set_blendmode(bm_one);
		        draw_surface(sl_layers_surface[i1],0,0); 
		    }
		    gpu_set_blendmode(bm_normal);
    
		    draw_set_alpha(-sl_ambientshadows_alpha+1);
		    draw_rectangle_color(0,0,(camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize,c_white,c_white,c_white,c_white,0);
		    draw_set_alpha(1);
    
		    surface_reset_target();
		}*/
	#endregion

		/// - LUMIERES
		for (i1=0; global.sl_lightlist[i1]!=-1; i1+=1) with global.sl_lightlist[i1]
		{
		    if !surface_exists(global.sl_light_gbuffer) global.sl_light_gbuffer = create_surface(global.sl_light_txsize,global.sl_light_txsize);
		    sl_light_refreshcounter -= 1;          // ! !!!!!!!! ???? original !!!! sl_light_refreshcounter -= 1;
    
		    sl_sz = global.sl_light_txsize * 0.5;
    
		    if sl_light_active
		    && sl_light_x < camera_get_view_x(cam)+camera_get_view_width(global.camera)+sl_sz*sl_light_xscale && sl_light_x > camera_get_view_x(cam)-sl_sz*sl_light_xscale
		    && sl_light_y < camera_get_view_y(cam)+camera_get_view_height(global.camera)+sl_sz*sl_light_yscale && sl_light_y > camera_get_view_y(cam)-sl_sz*sl_light_yscale
		    { 
		        sl_light_visible = true;
        
		        if sl_light_refresh && sl_light_refreshcounter<=0 refresh=true else refresh=false;
        
		        if refresh or !surface_exists(sl_light_surface)
		        {
		            if !surface_exists(sl_light_surface)
		            {
						// ?
						// !
						// It may be my error
		                //instance_activate_region(sl_light_x-sl_sz*sl_light_xscale,sl_light_y-sl_sz*sl_light_yscale,global.sl_light_txsize*sl_light_xscale,global.sl_light_txsize*sl_light_yscale,true);
		                sl_light_surface = create_surface(global.sl_light_txsize,global.sl_light_txsize);
		            }
            
		            if sl_light_castshadow // Conception du sample
		            {
		                sl_xs = min(1,other.sl_buffer_width  / (global.sl_light_txsize * sl_light_xscale));
		                sl_ys = min(1,other.sl_buffer_height / (global.sl_light_txsize * sl_light_yscale));
		                sl_ss = min(sl_xs,sl_ys);
                
		                sl_xs = global.sl_light_txsize / (global.sl_light_txsize * sl_light_xscale * sl_ss);
		                sl_ys = global.sl_light_txsize / (global.sl_light_txsize * sl_light_yscale * sl_ss);
                
		                sl_xx = sl_sz * sl_light_xscale;
		                sl_yy = sl_sz * sl_light_yscale;
		                sl_w1 = sl_light_x + sl_xx  sl_w2 = sl_light_x - sl_xx;
		                sl_h1 = sl_light_y + sl_yy  sl_h2 = sl_light_y - sl_yy;
                
		                surface_set_target(other.sl_buffer_surface1);
		                draw_clear(c_white);
                
		                for (i2=0; sl_light_shadowlist[i2,0]!=-1; i2+=1) with sl_light_shadowlist[i2,0] if visible && x<other.sl_w1+sprite_width && x>other.sl_w2-sprite_width && y<other.sl_h1+sprite_height && y>other.sl_h2-sprite_height
		                {var shspr if other.sl_light_shadowlist[other.i2,1]>-1 shspr=other.sl_light_shadowlist[other.i2,1] else shspr=sprite_index;
		                 draw_sprite_ext(shspr,floor(image_index),(x-other.sl_light_x+other.sl_xx)*other.sl_ss,(y-other.sl_light_y+other.sl_yy)*other.sl_ss,image_xscale*other.sl_ss,image_yscale*other.sl_ss,image_angle,c_black,image_alpha*other.sl_light_shadowsharpness)};
            
		                for (i2=0; global.sl_earthlist[i2,0]!=-1; i2+=1) if global.sl_earthlist[i2,3] = true
		                draw_sprite_ext(global.sl_earthlist[i2,4],global.sl_earthlist[i2,5],(global.sl_earthlist[i2,6]-sl_light_x+sl_xx)*sl_ss,(global.sl_earthlist[i2,7]-sl_light_y+sl_yy)*sl_ss,global.sl_earthlist[i2,9]*sl_ss,global.sl_earthlist[i2,10]*sl_ss,global.sl_earthlist[i2,11],c_black,global.sl_earthlist[i2,12]*sl_light_shadowsharpness);
                
		                surface_reset_target();
                
		                surface_set_target(global.sl_light_gbuffer);
		                draw_clear(c_white);
                
		                gpu_set_blendmode_ext(bm_dest_color,bm_zero);
		                draw_surface_ext(other.sl_buffer_surface1,0,0,sl_xs,sl_ys,0,c_white,1);
                
		                surface_reset_target();
		            }
            
		            gpu_set_blendmode_ext(bm_dest_color,bm_zero);
            
		            sl_spi = 1  sl_sps = 0; 
		            for (i2=1; i2<=sl_light_shadowlength; i2+=1) // Projection des ombres
		            {
		                surface_set_target(sl_light_surface);
		                draw_clear(c_white);
		                sl_sps = power(sl_light_shadowfactor,sl_spi);
		                gpu_set_tex_filter(0);
		                draw_surface(global.sl_light_gbuffer,0,0);
		                gpu_set_tex_filter(1)
		                draw_surface_ext(global.sl_light_gbuffer,sl_sz-sl_sz*sl_sps,sl_sz-sl_sz*sl_sps,sl_sps,sl_sps,0,c_white,1);
		                sl_spi *= 2;
		                surface_reset_target();
                
		                surface_set_target(global.sl_light_gbuffer);
		                draw_clear(c_white);
		                sl_sps = power(sl_light_shadowfactor,sl_spi);
		                gpu_set_tex_filter(0);
		                draw_surface(sl_light_surface,0,0);
		                gpu_set_tex_filter(1)
		                draw_surface_ext(sl_light_surface,sl_sz-sl_sz*sl_sps,sl_sz-sl_sz*sl_sps,sl_sps,sl_sps,0,c_white,1);
		                sl_spi *= 2;
		                surface_reset_target();
		            }
            
		            surface_set_target(sl_light_surface); // Composition finale
		            draw_clear(c_black);
            
		            gpu_set_blendmode(bm_normal);
		             draw_sprite_ext(sl_light_texture,0,sl_sz,sl_sz,1,1,sl_light_angle,c_white,-sl_light_ambientpower+1);
		            gpu_set_blendmode_ext(bm_dest_color,bm_zero);
		             if sl_light_castshadow draw_surface(global.sl_light_gbuffer,0,0);
		            gpu_set_blendmode(bm_add);
		             draw_sprite_ext(sl_light_texture,0,sl_sz,sl_sz,1,1,sl_light_angle,c_white,sl_light_ambientpower);
            
		            gpu_set_blendmode_ext(bm_src_color,bm_one);
		            draw_set_color(c_black);
		            draw_rectangle(0,0,global.sl_light_txsize,global.sl_light_txsize,0);
		            draw_set_color(c_white);
            
		            gpu_set_blendmode(bm_normal);
		            surface_reset_target();
		        }
		    }
		    else
		    {
		        sl_light_visible = false;
        
		        if surface_exists(sl_light_surface)
		        {
		            free_surface(sl_light_surface);
		            sl_light_surface = -1;
		        }
		    }
    
		    if sl_light_refreshcounter <= 0  sl_light_refreshcounter = (1-sl_light_refreshrate)*10+1             // ! !!! ??? original !! sl_light_refreshcounter = sl_light_refreshrate;
		}

	#region DELETED
		/// - BUFFER

		// Calcul des composantes de la lumière ambiante
		// ? was original
		/*
		if sl_tod_active
		{
		    r = ((global.sl_time-sl_tod[sl_tod_index,0])/(sl_tod[sl_tod_index+1,0]-sl_tod[sl_tod_index,0]))*(sl_tod[sl_tod_index+1,1]-sl_tod[sl_tod_index,1])+sl_tod[sl_tod_index,1];
		    g = ((global.sl_time-sl_tod[sl_tod_index,0])/(sl_tod[sl_tod_index+1,0]-sl_tod[sl_tod_index,0]))*(sl_tod[sl_tod_index+1,2]-sl_tod[sl_tod_index,2])+sl_tod[sl_tod_index,2];
		    b = ((global.sl_time-sl_tod[sl_tod_index,0])/(sl_tod[sl_tod_index+1,0]-sl_tod[sl_tod_index,0]))*(sl_tod[sl_tod_index+1,3]-sl_tod[sl_tod_index,3])+sl_tod[sl_tod_index,3];
		    sl_ambient_color = make_color_rgb(r,g,b);
		}
		*/
	#endregion

		surface_set_target(sl_buffer_surface1); // Buffer global
		draw_clear(c_black);

		draw_set_alpha(global.sl_ambient_light);
		draw_rectangle_color(0,0,(camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize,sl_ambient_color,sl_ambient_color,sl_ambient_color,sl_ambient_color,0);
		draw_set_alpha(1);

	#region DELETED
		// ? was active
		/*
		if sl_sunshadows_active && sl_layers_count > 0 if sl_sunshadows_light < 1
		{
		    gpu_set_blendmode_ext(bm_dest_color,bm_zero);
		    draw_surface(sl_sunshadows_surface2,0,0);
		}*/
	#endregion

		gpu_set_blendmode(bm_add);
		for (i=0; global.sl_lightlist[i]!=-1; i+=1) with global.sl_lightlist[i] if sl_light_visible && surface_exists(sl_light_surface)
		 draw_surface_ext(sl_light_surface,(sl_light_x-(global.sl_light_txsize*sl_light_xscale)/2-camera_get_view_x(cam)+other.sl_buffer_xmargin)*other.sl_buffer_texturesize,(sl_light_y-(global.sl_light_txsize*sl_light_yscale)/2-camera_get_view_y(cam)+other.sl_buffer_ymargin)*other.sl_buffer_texturesize,sl_light_xscale*other.sl_buffer_texturesize,sl_light_yscale*other.sl_buffer_texturesize,0,sl_light_color,sl_light_power);
		for (i=0; global.sl_texlist_light[i,0]!=-1; i+=1)
		 draw_sprite_ext(global.sl_texlist_light[i,0],global.sl_texlist_light[i,1],(global.sl_texlist_light[i,2]-camera_get_view_x(cam)+other.sl_buffer_xmargin)*sl_buffer_texturesize,(global.sl_texlist_light[i,3]-camera_get_view_y(cam)+other.sl_buffer_ymargin)*sl_buffer_texturesize,global.sl_texlist_light[i,4]*sl_buffer_texturesize,global.sl_texlist_light[i,5]*sl_buffer_texturesize,global.sl_texlist_light[i,6],global.sl_texlist_light[i,7],global.sl_texlist_light[i,8]);

	#region DELETED
		// ? was active
		/*
		if sl_ambientshadows_active && sl_layers_count > 0 if !sl_ambientshadows_lock
		{
		    gpu_set_blendmode_ext(bm_dest_color,bm_zero);
		    draw_surface(sl_ambientshadows_surface,0,0);
		}*/
	#endregion

		surface_reset_target();

		surface_set_target(sl_buffer_surface2); // Buffer de surexposition
		draw_clear(c_black);
 
		gpu_set_blendmode(bm_add);
		for (i=0; global.sl_lightlist[i]!=-1; i+=1) with global.sl_lightlist[i] if sl_light_visible && surface_exists(sl_light_surface)
		 draw_surface_ext(sl_light_surface,(sl_light_x-(global.sl_light_txsize*sl_light_xscale)/2-camera_get_view_x(cam)+other.sl_buffer_xmargin)*other.sl_buffer_texturesize,(sl_light_y-(global.sl_light_txsize*sl_light_yscale)/2-camera_get_view_y(cam)+other.sl_buffer_ymargin)*other.sl_buffer_texturesize,sl_light_xscale*other.sl_buffer_texturesize,sl_light_yscale*other.sl_buffer_texturesize,0,sl_light_color,sl_light_power);
		for (i=0; global.sl_texlist_light[i,0]!=-1; i+=1)
		 draw_sprite_ext(global.sl_texlist_light[i,0],global.sl_texlist_light[i,1],(global.sl_texlist_light[i,2]-camera_get_view_x(cam)+other.sl_buffer_xmargin)*sl_buffer_texturesize,(global.sl_texlist_light[i,3]-camera_get_view_y(cam)+other.sl_buffer_ymargin)*sl_buffer_texturesize,global.sl_texlist_light[i,4]*sl_buffer_texturesize,global.sl_texlist_light[i,5]*sl_buffer_texturesize,global.sl_texlist_light[i,6],global.sl_texlist_light[i,7],global.sl_texlist_light[i,8]);
 
	#region DELETED
		 // ? was active
		/*
		if sl_sunshadows_active && sl_layers_count > 0 if sl_sunshadows_light < 1
		{
		    gpu_set_blendmode_ext(bm_dest_color,bm_zero);
		    draw_surface(sl_sunshadows_surface2,0,0);
		}
		*/
	#endregion
	
		gpu_set_blendmode(bm_normal);
		draw_set_alpha(-min(global.sl_ambient_light,sl_maxexposure)+1);
		draw_rectangle_color(0,0,(camera_get_view_width(global.camera)+sl_buffer_xmargin*2)*sl_buffer_texturesize,(camera_get_view_height(global.camera)+sl_buffer_ymargin*2)*sl_buffer_texturesize,c_black,c_black,c_black,c_black,0);
		draw_set_alpha(1);

		gpu_set_blendmode(bm_normal);
		surface_reset_target();

		// Réinitialisation des listes des sprites affichées dans le buffer
		global.sl_earthlist[0,0]       = -1;
		global.sl_earthlist_index      = 0;
		global.sl_texlist_light[0,0]   = -1;
		global.sl_texlist_light_index  = 0;
	
		draw_set_color(c_black) // ? Ben ekledim.
	}


}
