/*
 *  Inspired by Cinder CubeMap David Wicks on 2/27/09.
 *  Ported to oF by brenfer on 7/2/10.
 *  Updated for of 007 and extended by James George 2/13/11
 *
 *  Made working-happily by Joshy-pants and James George
 *
 *  Some modification by Andreas Müller to be OpenGL ES 2.0 compatible 
 *
 * 
 *  Not copyrighted, no rights reserved, long live Christiania.
 *
 */

#ifndef	OFX_CUBE_MAP_H
#define OFX_CUBE_MAP_H

#include "ofMain.h"

class ofxCubeMap
{
public:
	
	unsigned int textureObject;	
	
	//these should all be the same size
	// and all power of two, i.e. 256, 512, 1024 (I think)
	void loadImages( string pos_x, string pos_y, string pos_z, string neg_x,string neg_y,string neg_z);
	void loadFromOfImages( ofImage pos_x, ofImage pos_y, ofImage pos_z, ofImage neg_x,ofImage neg_y,ofImage neg_z);
	
	void bindMulti( int pos )
	{
		_ofActiveTexture(GL_TEXTURE0 + pos );
		_ofBindTexture(GL_TEXTURE_CUBE_MAP, textureObject);
	}

	void bind()
	{
		_ofBindTexture(GL_TEXTURE_CUBE_MAP, textureObject);
	}

	void unbind()
	{
		_ofBindTexture(GL_TEXTURE_CUBE_MAP, 0 );
	}

	void enableFixedMapping()
	{
#ifndef TARGET_OPENGLES
		glTexGeni( GL_S, GL_TEXTURE_GEN_MODE, GL_REFLECTION_MAP );
		glTexGeni( GL_T, GL_TEXTURE_GEN_MODE, GL_REFLECTION_MAP );
		glTexGeni( GL_R, GL_TEXTURE_GEN_MODE, GL_REFLECTION_MAP );
		glEnable(GL_TEXTURE_GEN_S);
		glEnable(GL_TEXTURE_GEN_T);
		glEnable(GL_TEXTURE_GEN_R);
#endif		
		_ofEnable( GL_TEXTURE_CUBE_MAP );
	}

	void disableFixedMapping()
	{
#ifndef TARGET_OPENGLES		
		glDisable(GL_TEXTURE_GEN_S);
		glDisable(GL_TEXTURE_GEN_T);
		glDisable(GL_TEXTURE_GEN_R);
#endif
		_ofDisable( GL_TEXTURE_CUBE_MAP );
	}
};

#endif //OFX_CUBE_MAP_H

