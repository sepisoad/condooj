#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_opengl.h>
#include "../config/config.hh"
#include "../user/user.hh"
#include "../encryption/protection.hh"
#include "../dropbox/dropbox.hh"
#include "../imgui/imgui.hh"
#include "../app/app.hh"
#include "gui_app.hh"

void render_draw_list_callback(	ImDrawList** const cmd_lists, int cmd_lists_count);

SDL_Window* gp_window = 0;
SDL_Renderer* gp_renderer = 0; 
SDL_GLContext* gp_glcontext;
int g_window_x = 100;
int g_window_y = 100;
int g_window_w = 400;
int g_window_h = 400;

int start_gui_app()
{
	int was_successful = 0;
	SDL_Window* window = 0;
	SDL_Renderer* renderer = 0; 
	SDL_Event event;
	
	do{
		if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
		{
			printf("SDL_Init Error: %s\n", SDL_GetError());
			break;
		}
		
		window = SDL_CreateWindow(	"Condooj", 
									g_window_x, 
									g_window_y, 
									g_window_w, 
									g_window_h, 
									SDL_WINDOW_SHOWN);
		if (window == 0)
		{
			printf("SDL_CreateWindow Error: %s\n", SDL_GetError());
			break;
		}
		gp_window = window;
		
		renderer = SDL_CreateRenderer(	window, 
										-1, 
										SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
		if (renderer == 0)
		{
			printf("SDL_CreateRenderer Error: %s\n", SDL_GetError());
			break;
		}
		gp_renderer = renderer;
		
		ImGuiIO& io = ImGui::GetIO();
		ImGui::GetDefaultFontData(0, 0, 0, 0);
		
		io.DisplaySize = ImVec2((float)g_window_w, (float)g_window_h);
		io.DeltaTime = 1.0f/60.0f;
		io.PixelCenterOffset = 0.0f;
		io.RenderDrawListsFn = render_draw_list_callback;
		
		int can_exit = 0;
		bool can_show = true;
		
		while(!can_exit)
		{
			while(SDL_PollEvent(&event))
			{
				if(SDL_QUIT == event.type)
					can_exit = 1;
			}
			
			static double s_time = 0.0f;
			const double current_time = SDL_GetTicks();
			
			io = ImGui::GetIO();
			io.DeltaTime = (double)(current_time - s_time);
			s_time = current_time;
			ImGui::NewFrame();
			
			SDL_SetRenderDrawColor(renderer, 50, 50, 50, 255);
			SDL_RenderClear(renderer);
			
			{
				ImGui::NewFrame();
				ImGui::SetNewWindowDefaultPos(ImVec2(g_window_x, g_window_y)); 
				ImGui::ShowTestWindow(&can_show);
				ImGui::Text("Application average");			
				ImGui::Render();
			}
			
			ImGui::Render();
			
			SDL_RenderPresent(renderer);
			
			
		}
				
		was_successful = 1;
	}while(0);

	if(!was_successful)
	{
	
	}
	
	if(renderer)
	{
		SDL_DestroyRenderer(renderer);
	}
	
	if(window)
	{
		SDL_DestroyWindow(window);	
	}
	
	ImGui::Shutdown();
	SDL_Quit();

	return was_successful;
}

void render_draw_list_callback(ImDrawList** const cmd_lists, int cmd_lists_count)
{
    if (cmd_lists_count == 0)
        return;

//    const float width = ImGui::GetIO().DisplaySize.x;
//    const float height = ImGui::GetIO().DisplaySize.y;
    
    for (int n = 0; n < cmd_lists_count; n++)
    {
        const ImDrawList* cmd_list = cmd_lists[n];
        const ImDrawVert* vtx_buffer = (const ImDrawVert*)cmd_list->vtx_buffer.begin();

		SDL_SetRenderDrawColor(gp_renderer, 0, 00, 255, 255);				
		if(SDL_RenderDrawLine(	gp_renderer, 
								vtx_buffer->pos.x,
								vtx_buffer->pos.y,
								vtx_buffer->uv.x,
								vtx_buffer->uv.y))
		{
			printf("shit\n");
		}
        
        int vtx_offset = 0;
        const ImDrawCmd* pcmd_end = cmd_list->commands.end();
        for (const ImDrawCmd* pcmd = cmd_list->commands.begin(); pcmd != pcmd_end; pcmd++)
        {
            vtx_offset += pcmd->vtx_count;
        }
    }
}
