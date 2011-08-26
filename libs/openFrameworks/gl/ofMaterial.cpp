#include "ofMaterial.h"
#include "ofConstants.h"

ofMaterial::ofMaterial() {

    diffuse.set(0.8f, 0.8f, 0.8f, 1.0f);
    specular.set(0.0f, 0.0f, 0.0f, 1.0f);
    ambient.set(0.2f, 0.2f, 0.2f, 1.0f);
    emissive.set(0.0f, 0.0f, 0.0f, 1.0f);
    shininess = 20.0; // Range is 0..128
}

void ofMaterial::setColors(ofFloatColor oDiffuse, ofFloatColor oAmbient, ofFloatColor oSpecular, ofFloatColor oEmissive) {
	setDiffuseColor(oDiffuse);
	setAmbientColor(oAmbient);
	setSpecularColor(oSpecular);
	setEmissiveColor(oEmissive);
}

void ofMaterial::setDiffuseColor(ofFloatColor oDiffuse) {
	diffuse = oDiffuse;
}

void ofMaterial::setAmbientColor(ofFloatColor oAmbient) {
	ambient = oAmbient;
}

void ofMaterial::setSpecularColor(ofFloatColor oSpecular) {
	specular = oSpecular;
}

void ofMaterial::setEmissiveColor(ofFloatColor oEmissive) {
	emissive = oEmissive;
}

void ofMaterial::setShininess(float nShininess) {
	shininess = nShininess;
}

float ofMaterial::getShininess(){
	return shininess;
}

ofFloatColor ofMaterial::getDiffuseColor() {
	return diffuse;
}

ofFloatColor ofMaterial::getAmbientColor() {
	return ambient;
}

ofFloatColor ofMaterial::getSpecularColor() {
	return specular;
}

ofFloatColor ofMaterial::getEmissiveColor() {
	return emissive;
}

void ofMaterial::begin() {
	
    // save previous values, opengl es cannot use push/pop attrib (Andreas: getting an error from this in OpenGL ES )
	
#ifndef TARGET_OPENGLES	
	_ofGetMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE,&prev_diffuse.r);
	_ofGetMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,&prev_specular.r);
	_ofGetMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT,&prev_ambient.r);
	_ofGetMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,&prev_emissive.r);
	_ofGetMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, &shininess);
#endif
	
    // Material colors and properties
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, &diffuse.r);
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, &specular.r);
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, &ambient.r);
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, &emissive.r);
	_ofMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, shininess);
}

void ofMaterial::end() {
	
#ifndef TARGET_OPENGLES		
    // Set previous material colors and properties
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, &prev_diffuse.r);
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, &prev_specular.r);
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, &prev_ambient.r);
	_ofMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, &prev_emissive.r);
	_ofMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, prev_shininess);
#endif	
}

