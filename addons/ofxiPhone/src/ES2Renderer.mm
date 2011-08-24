

#import "ES2Renderer.h"

// uniform index
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// attribute index
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface ES2Renderer (PrivateMethods)
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation ES2Renderer

// Create an OpenGL ES 2.0 context
- (id)init
{
	return [self initWithDepth:false andAA:false andFSAASamples:0 andRetina:false];
}

- (id)initWithDepth:(bool)depth andAA:(bool)fsaa andFSAASamples:(int)samples andRetina:(bool)retina
{
    if ((self = [super init]))
    {
		depthEnabled = depth;
		fsaaEnabled = fsaa;
		fsaaSamples = samples;
		retinaEnabled = retina;
		
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		NSLog(@"Creating OpenGL ES2 Renderer");

        if (!context || ![EAGLContext setCurrentContext:context] )
        {
			NSLog(@"OpenGL ES2 failed");
            [self release];
            return nil;
        }

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffers(1, &defaultFramebuffer);
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
    }

    return self;
}

-(EAGLContext*) context
{
	return context;
}

- (void)startRender
{
    [EAGLContext setCurrentContext:context];
	
    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
 	
	
}


- (void)finishRender
{

    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER];
}


- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{
    // Allocate color buffer backing based on the current layer size
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);

	NSLog(@"ES2Renderer, resizeFromLayer: backing dimensions %i x %i", backingWidth, backingHeight);		
	
	glGenRenderbuffers(1, &depthRenderbuffer); 
	glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer); 
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight); 
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);	

    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"ES2Renderer: Failed to make complete framebuffer object %x %i %i", glCheckFramebufferStatus(GL_FRAMEBUFFER), backingWidth, backingHeight);
        return NO;
    }


    return YES;
}

- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffers(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffers(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }

	if(depthRenderbuffer) {
		glDeleteRenderbuffers(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}


    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    [context release];
    context = nil;

    [super dealloc];
}

@end
