-- **************************************************************
-- @class Frame
--
-- Draw a frame in the main window
-- 
-- Keys: "x","y","width","height","children"
-- Defaults: 
--
-- **************************************************************

Frame = {};
Frame.__index = Frame;

function Frame.new(...)
	local args = {...};
	local class = {};
	setmetatable(class,Frame);

	local keys = {"x","y","width","height","children"};
	local defaults = {1,1,term.getSize(),{}};

	for i = 1,math.min(#args,#keys) do
		class[keys[i]] = args[i];
	end
	for i = #args+1,#keys do
		class[keys[i]] = defaults[i];
	end

	class.children = {};

	return class;
end

function Frame:draw()
	for i = 1,#self.children do
		self.children[i]:draw(self.width,self.height,self.x,self.y);
	end
end

function Frame:clear()
	local x,y = term.getCursorPos();

	local image = {};
	for rows = 1,self.height do
		image[rows] = {};
		for cols = 1,self.width do
			image[rows][cols] = colours.black;
		end
	end

	paintutils.drawImage(image,self.x,self.y);
	term.setCursorPos(x,y);
end

function Frame:addChild(child)
	if child.draw then
		self.children[#self.children+1] = child;
	end
end
