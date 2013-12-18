-- **************************************************************
-- @class Rectangle
--
-- A rectangle element for CC GUIs
-- 
-- Keys: "x","y","width","height","bgColour"
-- Defaults: 1,1,1,1,colours.black
--
-- **************************************************************

Rectangle = {};
Rectangle.__index = Rectangle;

function Rectangle.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Rectangle);

	local keys = {"x","y","width","height","bgColour"};
	local defaults = {1,1,1,1,colours.black};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	return class;
end

function Rectangle:draw(...)
	local args = {...};
	local x,y = term.getCursorPos();
	local maxX,maxY = term.getSize();
	local minX,minY = 1,1;

	if #args > 1 then
		maxX = args[1];
		maxY = args[2];
	elseif #args == 1 then
		minX, minY = args[1].x, args[1].y;
		maxX, maxY = minX+args[1].width, minY+args[1].height;
	end
	if #args > 2 then
		minX = args[3];
		minY = args[4];
	end

	for i = math.max(minX,self.x),math.min(maxX,self.x+self.width) do
		for j = math.max(minY,self.y),math.min(maxY,self.y+self.height) do
			paintutils.drawPixel(i,j,self.bgColour);
		end
	end 

	term.setCursorPos(x,y);
end