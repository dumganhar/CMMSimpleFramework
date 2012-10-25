//  Created by JGroup(kimbobv22@gmail.com)

#import "CMMSpriteBatchBar.h"

@implementation CMMSpriteBatchBar
@synthesize targetSprite,edgeSize;

+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_{
	return [[[self alloc] initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:edgeSize_] autorelease];
}
+(id)batchBarWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_{
	return [[[self alloc] initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_] autorelease];
}

-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_ edgeSize:(CGSize)edgeSize_{
	if(!(self = [super init])) return self;
	
	[self setIgnoreAnchorPointForPosition:NO];
	[self setAnchorPoint:ccp(0.0f,0.0f)];
	
	edgeSize = edgeSize_;
	[self setTargetSprite:[CCSprite spriteWithTexture:[targetSprite_ texture] rect:[targetSprite_ textureRect]]];
	[self setContentSize:batchBarSize_];
	
	return self;
}
-(id)initWithTargetSprite:(CCSprite *)targetSprite_ batchBarSize:(CGSize)batchBarSize_{
	CGSize edgeSize_ = CGSizeDiv([targetSprite_ contentSize], 2.0f);
	edgeSize_ = CGSizeSub(edgeSize_, CGSizeMake(1.0f, 1.0f));
	return [self initWithTargetSprite:targetSprite_ batchBarSize:batchBarSize_ edgeSize:edgeSize_];
}

-(void)setContentSize:(CGSize)contentSize{
	CGSize targetSpriteSize_ = [targetSprite contentSize];
	if(contentSize.width < targetSpriteSize_.width)
		contentSize.width = targetSpriteSize_.width;
	if(contentSize.height < targetSpriteSize_.height)
		contentSize.height = targetSpriteSize_.height;
	
	[super setContentSize:contentSize];
	_isDirty = YES;
}

-(void)setColor:(ccColor3B)color{
	[_barTopSprite setColor:color];
	[_barBottomSprite setColor:color];
	[_barLeftSprite setColor:color];
	[_barRightSprite setColor:color];
	[_backSprite setColor:color];
	[_edge1Sprite setColor:color];
	[_edge2Sprite setColor:color];
	[_edge3Sprite setColor:color];
	[_edge4Sprite setColor:color];
}
-(ccColor3B)color{
	return [_backSprite color];
}

-(GLubyte)opacity{
	return [_backSprite opacity];
}
-(void)setOpacity:(GLubyte)opacity{
	[_barTopSprite setOpacity:opacity];
	[_barBottomSprite setOpacity:opacity];
	[_barLeftSprite setOpacity:opacity];
	[_barRightSprite setOpacity:opacity];
	[_backSprite setOpacity:opacity];
	[_edge1Sprite setOpacity:opacity];
	[_edge2Sprite setOpacity:opacity];
	[_edge3Sprite setOpacity:opacity];
	[_edge4Sprite setOpacity:opacity];
}

-(void)setTargetSprite:(CCSprite *)targetSprite_{
	[self removeAllChildrenWithCleanup:YES];
	[targetSprite release];
	targetSprite = [targetSprite_ retain];
	
	if(targetSprite){
		[self setTexture:[targetSprite texture]];
		CCTexture2D *targetTexture_ = [self texture];
		[targetTexture_ setAliasTexParameters];
		_targetSpriteOrgTextureRect = [targetSprite textureRect];
		
		/// make batch bar ///
		
		CGPoint targetSpriteTexturePoint_ = _targetSpriteOrgTextureRect.origin;
		CGSize targetSpriteTextureSize_ = _targetSpriteOrgTextureRect.size;
		CGRect drawRect_ = CGRectZero;
		
		//top
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + edgeSize.width, targetSpriteTexturePoint_.y+targetSpriteTextureSize_.height/2.0f);
		drawRect_.size = CGSizeMake(targetSpriteTextureSize_.width-edgeSize.width*2.0f, targetSpriteTextureSize_.height/2.0f);
		_barTopSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barTopSprite setBatchNode:self];
		[self addChild:_barTopSprite z:1];
		
		//bottom
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + edgeSize.width, targetSpriteTexturePoint_.y);
		_barBottomSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barBottomSprite setBatchNode:self];
		[self addChild:_barBottomSprite z:1];
		
		//left
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y+edgeSize.height);
		drawRect_.size = CGSizeMake(targetSpriteTextureSize_.width/2.0f, targetSpriteTextureSize_.height-edgeSize.height*2.0f);
		_barLeftSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barLeftSprite setBatchNode:self];
		[self addChild:_barLeftSprite z:1];
		
		//right
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + targetSpriteTextureSize_.width/2.0f, targetSpriteTexturePoint_.y+edgeSize.height);
		_barRightSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_barRightSprite setBatchNode:self];
		[self addChild:_barRightSprite z:1];
		
		//back(center)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + edgeSize.width, targetSpriteTexturePoint_.y + edgeSize.height);
		drawRect_.size = CGSizeMake(targetSpriteTextureSize_.width-edgeSize.width*2.0f, targetSpriteTextureSize_.height-edgeSize.height*2.0f);
		_backSprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_backSprite setBatchNode:self];
		[self addChild:_backSprite z:0];
		
		//edge1(top-left)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y);
		drawRect_.size = edgeSize;
		_edge1Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge1Sprite setBatchNode:self];
		[self addChild:_edge1Sprite z:0];
		
		//edge2(top-right)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + (targetSpriteTextureSize_.width-edgeSize.width), targetSpriteTexturePoint_.y);
		drawRect_.size = edgeSize;
		_edge2Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge2Sprite setBatchNode:self];
		[self addChild:_edge2Sprite z:0];
		
		//edge3(bottom-left)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x, targetSpriteTexturePoint_.y + (targetSpriteTextureSize_.height - edgeSize.height));
		drawRect_.size = edgeSize;
		_edge3Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge3Sprite setBatchNode:self];
		[self addChild:_edge3Sprite z:0];
		
		//edge4(bottom-left)
		drawRect_.origin = ccp(targetSpriteTexturePoint_.x + (targetSpriteTextureSize_.width-edgeSize.width), targetSpriteTexturePoint_.y + (targetSpriteTextureSize_.height - edgeSize.height));
		drawRect_.size = edgeSize;
		_edge4Sprite = [CCSprite spriteWithTexture:targetTexture_ rect:drawRect_];
		[_edge4Sprite setBatchNode:self];
		[self addChild:_edge4Sprite z:0];
		
		_isDirty = YES;
	}
}

-(void)visit{
	if(_isDirty){
		CGSize spriteSize_ = [_barTopSprite contentSize];
		
		//top
		[_barTopSprite setScaleX:(contentSize_.width-edgeSize.width*2.0f)/spriteSize_.width];
		[_barTopSprite setPosition:ccp(contentSize_.width/2.0f,spriteSize_.height/2.0f)];
		
		//bottom
		[_barBottomSprite setScaleX:(contentSize_.width-edgeSize.width*2.0f)/spriteSize_.width];
		[_barBottomSprite setPosition:ccp(contentSize_.width/2.0f,contentSize_.height-spriteSize_.height/2.0f)];
		
		spriteSize_ = [_barLeftSprite contentSize];
		
		//left
		[_barLeftSprite setScaleY:(contentSize_.height-edgeSize.height*2.0f)/spriteSize_.height];
		[_barLeftSprite setPosition:ccp(spriteSize_.width/2.0f,contentSize_.height/2.0f)];
		
		//right
		[_barRightSprite setScaleY:(contentSize_.height-edgeSize.height*2.0f)/spriteSize_.height];
		[_barRightSprite setPosition:ccp(contentSize_.width-spriteSize_.width/2.0f,contentSize_.height/2.0f)];
		
		//(back)center
		spriteSize_ = [_backSprite contentSize];
		[_backSprite setScaleX:(contentSize_.width-edgeSize.width)/spriteSize_.width];
		[_backSprite setScaleY:(contentSize_.height-edgeSize.height)/spriteSize_.height];
		[_backSprite setPosition:ccp(contentSize_.width/2.0f,contentSize_.height/2.0f)];
		
		//edges
		[_edge1Sprite setPosition:ccp(edgeSize.width/2.0f,contentSize_.height-edgeSize.height/2.0f)];
		[_edge2Sprite setPosition:ccp(contentSize_.width-edgeSize.width/2.0f,contentSize_.height-edgeSize.height/2.0f)];
		[_edge3Sprite setPosition:ccp(edgeSize.width/2.0f,edgeSize.height/2.0f)];
		[_edge4Sprite setPosition:ccp(contentSize_.width-edgeSize.width/2.0f,edgeSize.height/2.0f)];
		
		_isDirty = NO;
	}
	
	[super visit];
}

-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchBegan:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchMoved:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchEnded:(UITouch *)touch_ event:(UIEvent *)event_{}
-(void)touchDispatcher:(CMMTouchDispatcher *)touchDispatcher_ whenTouchCancelled:(UITouch *)touch_ event:(UIEvent *)event_{}

-(void)dealloc{
	[targetSprite release];
	[super dealloc];
}

@end
