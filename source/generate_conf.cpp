#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <string>

int main(int argc, char** argv) {
	if(argc != 2) return -1;
	char cmd[1024];
	sprintf(cmd, "iw dev %s info | grep channel | awk '{print $2}'", argv[1]);
	FILE* pipe = popen(cmd, "r");
	std::string channel("");
	char readbuffer[4096];
	while(fgets(readbuffer, 4096, pipe)) {
		channel += readbuffer;
	}
	pclose(pipe);
	int channel_num;
	sscanf(channel.c_str(), "%d", &channel_num);
	bool working_freq = channel_num > 15;
	if(working_freq) {
		//5GHz
		bool first_match = true;
		std::ifstream fin("5g.conf");
		std::string linebuffer;
		std::string channel_start = std::to_string(channel_num);
		std::string channel_mid = std::to_string(channel_num+6);
		while(std::getline(fin, linebuffer)) {
			size_t location = linebuffer.find("%s");
			if(location != std::string::npos) {
				if(first_match) {
					printf(linebuffer.c_str(), channel_start.c_str());
					printf("\n");
					first_match = false;
				}
				else {
					printf(linebuffer.c_str(), channel_mid.c_str());
					printf("\n");
				}
			}
			else {
				printf(linebuffer.c_str());
				printf("\n");
			}
		}
	}
	else {
		//2.4GHz
		std::ifstream fin("2_4g.conf");
		std::string linebuffer;
		std::string channel_start = std::to_string(channel_num);
		while(std::getline(fin, linebuffer)) {
			size_t location = linebuffer.find("%s");
			if(location != std::string::npos) {
				printf(linebuffer.c_str(), channel_start.c_str());
				printf("\n");
			}
			else {
				printf(linebuffer.c_str());
				printf("\n");
			}
		}
	}
	return 0;
}
