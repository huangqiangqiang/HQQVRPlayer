//
//  HQQVRSphereObject.m
//  Pods
//
//  Created by 黄强强 on 17/3/31.
//
//

#import "HQQVRSphereObject.h"

#define PI 3.14159265f

@interface HQQVRSphereObject()
@property (nonatomic, weak) HQQVRProgram *program;
@property (nonatomic, assign) float *vertices;
@property (nonatomic, assign) float *texCoords;
@property (nonatomic, assign) short *indices;
@property (nonatomic, assign) int numOfVertices;
@property (nonatomic, assign) int numOfTexCoords;
@property (nonatomic, assign) int numOfIndices;
@end

@implementation HQQVRSphereObject

+ (instancetype)objectWithProgram:(HQQVRProgram *)program
{
    return [[HQQVRSphereObject alloc] initWithProgram:program];
}

- (instancetype)initWithProgram:(HQQVRProgram *)program
{
    self = [super init];
    if (self) {
        [self createObject3D];
        [self updateVertex:program];
        [self updateTexture:program];
    }
    return self;
}

- (void)createObject3D
{
    [self generateSphere:18 numSlices:128];
}

- (void)generateSphere:(float)radius numSlices:(int)numSlices
{
    int i;
    int j;
    int numParallels = numSlices / 2;
    int numVertices = ( numParallels + 1 ) * ( numSlices + 1 );
    int numIndices = numParallels * numSlices * 6;
    float angleStep = (2.0f * PI) / ((float) numSlices);
    
    float *vertices = malloc ( sizeof(float) * 3 * numVertices );
    float *texCoords = malloc ( sizeof(float) * 2 * numVertices );
    
    short *indices = malloc ( sizeof(short) * numIndices );
    
    
    for ( i = 0; i < numParallels + 1; i++ ) {
        for ( j = 0; j < numSlices + 1; j++ ) {
            int vertex = ( i * (numSlices + 1) + j ) * 3;
            
            if ( vertices ) {
                vertices[vertex + 0] = - radius * sinf ( angleStep * (float)i ) * sinf ( angleStep * (float)j );
                vertices[vertex + 1] = radius * sinf ( PI/2 + angleStep * (float)i );
                vertices[vertex + 2] = radius * sinf ( angleStep * (float)i ) * cosf ( angleStep * (float)j );
            }
            if (texCoords) {
                int texIndex = ( i * (numSlices + 1) + j ) * 2;
                texCoords[texIndex + 0] = (float) j / (float) numSlices;
                texCoords[texIndex + 1] = ((float) i / (float) (numParallels));
            }
        }
    }
    
    if ( indices != NULL ) {
        short *indexBuf = indices;
        for ( i = 0; i < numParallels ; i++ ) {
            for ( j = 0; j < numSlices; j++ ) {
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + j);
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + j);
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + ( j + 1 ));
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + j);
                *indexBuf++ = (short)(( i + 1 ) * ( numSlices + 1 ) + ( j + 1 ));
                *indexBuf++ = (short)(i * ( numSlices + 1 ) + ( j + 1 ));
                
            }
        }
        
    }
    
    self.vertices = vertices;
    self.numOfVertices = numVertices;
    self.texCoords = texCoords;
    self.numOfTexCoords = numVertices;
    self.indices = indices;
    self.numOfIndices = numIndices;
}

- (void)updateVertex:(HQQVRProgram *)program
{
//    GLuint buffer;
//    glGenBuffers(1, &buffer);
//    glBindBuffer(GL_ARRAY_BUFFER, buffer);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * _numOfVertices, _vertices, GL_STATIC_DRAW);
    glEnableVertexAttribArray(program.a_PositionHandler);
//    glVertexAttribPointer(program.a_PositionHandler, 3, GL_FLOAT, GL_FALSE, sizeof(float) * 3, NULL);
    glVertexAttribPointer(program.a_PositionHandler, 3, GL_FLOAT, GL_FALSE, 0, self.vertices);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void)updateTexture:(HQQVRProgram *)program
{
//    GLuint texture;
//    glGenTextures(1, &texture);
//    glBindBuffer(GL_ARRAY_BUFFER, texture);
//    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * _numOfTexCoords, _texCoords, GL_STATIC_DRAW);
//    glEnableVertexAttribArray(program.a_TexCoordHandler);
//    glVertexAttribPointer(program.a_TexCoordHandler, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 2, NULL);
    
    glEnableVertexAttribArray(program.a_TexCoordHandler);
    glVertexAttribPointer(program.a_TexCoordHandler, 2, GL_FLOAT, GL_FALSE, 0, self.texCoords);
}

- (void)draw
{
//    glDrawArrays(GL_TRIANGLES, 0, _numOfVertices);
    glDrawElements(GL_TRIANGLE_STRIP, self.numOfIndices, GL_UNSIGNED_SHORT, self.indices);
}

- (void)dealloc
{
    NSLog(@"%@ ------ dealloc",self.class);
}

@end
