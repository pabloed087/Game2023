shader_type canvas_item;

//Outline color
uniform vec4 inputOutlineColor:hint_color = vec4(1.0,1.0,1.0,1.0);
//Outline size
uniform int outlineSize = 2;

//Texture size
uniform vec2 inputTextureSize = vec2(32.0,32.0);

//Outline directions
uniform bool hasTopOutline = true;
uniform bool hasBottomOutline = true;
uniform bool hasLeftOutline = true;
uniform bool hasRightOutline = true;

//Function returns true or false based on if there is a pixel in the directions provided based on a flood fill
bool hasPixelInDirection(vec2 passedUv, sampler2D passedTexture, vec2 pixelSizeUv, bool isTop, bool isBottom, bool isLeft, bool isRight){
	//Flood fill outwards by first extending in the x axis, then the y 
	//For outline size * 2 (left and right) + 1 (center)
	for(float x=0.0; x<float(outlineSize)*2.0+1.0; x++){
		//Get which cycle we're on (cycle 1, 2, etc.)
		float iterationNumberX = floor((x-1.0)/float(outlineSize))+1.0;
		//Get which direction this is referring to (if we're on cycle 1 we're + if we're on cycle 2 we're -)
		float dirX = (iterationNumberX-1.0)*2.0-1.0;
		//Get the local x distance relative to the current pixel
		float rawPosX = (x-(iterationNumberX-1.0)*float(outlineSize));
		//Convert that to + or - depending on our direction
		float resultX = rawPosX*dirX;
		//we're on item 1 (0.0) we need to set that manually since it breaks otherwise :P
		if(x==0.0){
			rawPosX = 0.0;
			resultX = 0.0;
		}
		
		//Get how many spaces we have left to move in our flood fill (Say we have an outline of 3 and we've gone out 1 x, that leaves 2 for the y.)
		float remainingSpaces = (float(outlineSize)-rawPosX);
		//For each of the remaining spaces * 2 (left and right) + 1 (center too)
		for(float y=0.0; y<remainingSpaces*2.0+1.0; y++){
			//Just like with x, get the iteration for determining + or -
			float iterationNumberY = floor((y-1.0)/remainingSpaces)+1.0;
			//Determine + or -
			float dirY = (iterationNumberY-1.0)*2.0-1.0;
			//Get the y distance from the current pixel
			float rawPosY = (y-(iterationNumberY-1.0)*(remainingSpaces));
			//Convert to + or -
			float resultY = rawPosY*dirY;
			//If 0 we set manually because it breaks otherwise
			if(y==0.0){
				rawPosY = 0.0;
				resultY = 0.0;
			}
			//If the pixel at that location is transparent
			if(texture(passedTexture,passedUv+vec2(resultX,resultY)*pixelSizeUv).a > 0.0){
				//If it's in a direction we don't want outlined
				if(
					sign(resultX) < 0.0 && !isRight ||
					sign(resultX) > 0.0 && !isLeft ||
					sign(resultY) < 0.0 && !isBottom ||
					sign(resultY) > 0.0 && !isTop
				){
					//Continue to the next loop iteration
					continue;
				}
				//This must be an outline we want, return true.
				return true;
			}
		}
	}
	//If we've reached this point, we must not have returned true yet. So no outline, return false.
	return false;
}

void vertex(){
	//Scale up the sprite's VERTEX based on outline size so we don't cut the offline off
	VERTEX *= (inputTextureSize+vec2(float(outlineSize)))/inputTextureSize;
}

void fragment(){
	//Get how big one pixel is in UV measurements
	vec2 pixelSizeUv = 1.0/inputTextureSize;
	//Expand the UV we're referencing based on the outline size (just like we did the VERTEX) to shrink the texture
	vec2 expandedUv = (UV-0.5)*(inputTextureSize+vec2(float(outlineSize)))/inputTextureSize+0.5;
	//If we're looking at a non transparent pixel
	if(texture(TEXTURE,expandedUv).a > 0.0){
		//Set its color
		COLOR = texture(TEXTURE,expandedUv);
	//Else, the pixel is transparent
	}else{
		//Check for a pixel in directions based on hasTopOutline, hasBottomOutline, etc.
		if(hasPixelInDirection(expandedUv,TEXTURE,pixelSizeUv,hasTopOutline,hasBottomOutline,hasLeftOutline,hasRightOutline)){
			//If true, output the outline color.
			COLOR = inputOutlineColor;
		}else{
			//Else, this is transparent
			COLOR = vec4(0.0);
		}
	}
}