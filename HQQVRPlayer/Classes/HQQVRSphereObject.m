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
@property (nonatomic, assign) float *vertices;
@property (nonatomic, assign) float *texCoords;
@property (nonatomic, assign) short *indices;
@property (nonatomic, assign) int numOfVertices;
@property (nonatomic, assign) int numOfTexCoords;
@property (nonatomic, assign) int numOfIndices;
@end

@implementation HQQVRSphereObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
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
    glEnableVertexAttribArray(program.a_PositionHandler);
    glVertexAttribPointer(program.a_PositionHandler, 3, GL_FLOAT, GL_FALSE, 0, self.vertices);
}

- (void)updateTexture:(HQQVRProgram *)program
{
    glEnableVertexAttribArray(program.a_TexCoordHandler);
    glVertexAttribPointer(program.a_TexCoordHandler, 2, GL_FLOAT, GL_FALSE, 0, self.texCoords);
}

- (void)draw
{
    glDrawElements(GL_TRIANGLE_STRIP, self.numOfIndices, GL_UNSIGNED_SHORT, self.indices);
}

@end
