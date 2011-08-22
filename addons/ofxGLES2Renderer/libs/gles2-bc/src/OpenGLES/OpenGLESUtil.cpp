/*
 Copyright 2009 Johannes Vuorinen
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at 
 
 http://www.apache.org/licenses/LICENSE-2.0 
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#include "OpenGLESUtil.h"
#ifdef __ANDROID__
#include <android/log.h>
#endif

using namespace OpenGLES;

void OpenGLESUtil::checkGlError(GLenum errorCode, const char *file, const unsigned int line)
{
	if (errorCode != GL_NO_ERROR)
	{
		std::string errorString;
		switch (errorCode) {
			case GL_INVALID_ENUM:
				errorString = "GL_INVALID_ENUM, enum argument out of range.";
				break;
			case GL_INVALID_VALUE:
				errorString = "GL_INVALID_VALUE, numeric argument out of range";
				break;
			case GL_INVALID_OPERATION:
				errorString = "GL_INVALID_OPERATION, operation illegal in current state";
				break;
			case GL_STACK_OVERFLOW:
				errorString = "GL_STACK_OVERFLOW, command would cause a stack overﬂow";
				break;
			case GL_STACK_UNDERFLOW:
				errorString = "GL_STACK_UNDERFLOW, command would cause a stack underﬂow";
				break;
			case GL_OUT_OF_MEMORY:
				errorString = "GL_OUT_OF_MEMORY, not enough memory left to execute command";
				break;
			case GL_INVALID_FRAMEBUFFER_OPERATION:
				errorString = "GL_INVALID_FRAMEBUFFER_OPERATION, framebuffer is incomplete";
				break;
			default:
				errorString = "Unknown GL error";
				break;
		}
		
		LOG_DEBUG_MESSAGE(file, line, OpenGLESString(" GL ERROR: ") + errorCode + " " + errorString + " **");
	}
}

void OpenGLESUtil::logMessage(const char *file, int line, OpenGLESString msg)
{
#ifndef __ANDROID__
	printf("** %s:%d %s\n", file, line, msg().c_str());
#else
	__android_log_print(ANDROID_LOG_INFO,"gles-bc","%s:%d %s\n", file, line, msg().c_str());
#endif
}

void OpenGLESUtil::logMessage(OpenGLESString msg)
{
#ifndef __ANDROID__
	printf("** %s\n", msg().c_str());
#else
	__android_log_print(ANDROID_LOG_INFO,"gles-bc", msg().c_str());
#endif
}

void OpenGLESUtil::print( const char* format, ... ) 
{
#ifndef __ANDROID__
	va_list args;
	va_start( args, format );
	vprintf(format, args );
	va_end( args );
#else
	va_list args;
	va_start( args, format );
	__android_log_vprint(ANDROID_LOG_INFO,"gles-bc",format,args);
	va_end( args );
#endif
}

void OpenGLESUtil::printBits(int val)
{
	for (int i = 0; i < 32; i++) {
		int mask = 1 << i;
		int bit = (val & mask) >> i;
#ifndef __ANDROID__
		printf("%d", bit);
#else
		__android_log_print(ANDROID_LOG_INFO,"gles-bc", "%d", bit);
#endif
	}
}
std::string OpenGLESUtil::enumToString(GLenum _enum)
{
	std::string stringRep = "UNKNOWN";

	switch (_enum) {
		case GL_ZERO:
			stringRep = "GL_ZERO";
			break;
		case GL_ONE:
			stringRep = "GL_ONE";
			break;
		case GL_SRC_COLOR:
			stringRep = "GL_SRC_COLOR";
			break;
		case GL_ONE_MINUS_SRC_COLOR:
			stringRep = "GL_ONE_MINUS_SRC_COLOR";
			break;
		case GL_SRC_ALPHA:
			stringRep = "GL_SRC_ALPHA";
			break;
		case GL_ONE_MINUS_SRC_ALPHA:
			stringRep = "GL_ONE_MINUS_SRC_ALPHA";
			break;
		case GL_DST_ALPHA:
			stringRep = "GL_DST_ALPHA";
			break;
		case GL_ONE_MINUS_DST_ALPHA:
			stringRep = "GL_ONE_MINUS_DST_ALPHA";
			break;
		case GL_DST_COLOR:
			stringRep = "GL_DST_COLOR";
			break;
		case GL_ONE_MINUS_DST_COLOR:
			stringRep = "GL_ONE_MINUS_DST_COLOR";
			break;	
		case GL_SRC_ALPHA_SATURATE:
			stringRep = "GL_SRC_ALPHA_SATURATE";
			break;				
		default:
			
			break;
	}
	
	return stringRep;
}


