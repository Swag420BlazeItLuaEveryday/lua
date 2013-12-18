-- **************************************************************
-- @class Text
--
-- A text box class for computer craft
-- 
-- Keys: "x","y","text","colour"
-- Defaults: Rectangle.new(),"Ok",colours.white
--
-- **************************************************************

Text = {};
Text.__index = Text;

function Text.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Text);

	local keys = {"x","y","text","colour","bgColour"};
	local defaults = {1,1,"Ok",nil,nil};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	return class;
end

function Text:draw(...)
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

	if self.colour then 
		term.setTextColour(self.colour);
	end
	if self.bgColour then
		term.setBackgroundColour(self.bgColour);
	end

	term.setCursorPos(self.x,self.y);
	term.write(self.text:sub(1,math.min(self.text:len(), maxX - self.x - self.text:len() - 1)));

	term.setCursorPos(x,y);
end