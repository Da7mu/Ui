--[=[
 d888b db db d888888b .d888b. db db db .d8b.
88' Y8b 88 88 `88' VP `8D 88 88 88 d8' `8b
88 88 88 88 odD' 88 88 88 88ooo88
88 ooo 88 88 88 .88' 88 88 88 88~~~88
88. ~8~ 88b d88 .88. j88. 88booo. 88b d88 88 88 @uniquadev
 Y888P ~Y8888P' Y888888P 888888D Y88888P ~Y8888P' YP YP CONVERTER
]=]

-- Da7mUI Library - Modern Sidebar Roblox UI Library
-- Load with: local Da7mUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/Da7mUI.lua"))()

local Da7mUI = {}
Da7mUI.__index = Da7mUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CreateInstance(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	return inst
end

function Da7mUI:CreateWindow(config)
	config = config or {}
	local self = setmetatable({}, Da7mUI)

	self.Tabs = {}
	self.CurrentTab = nil
	self.Config = config

	-- Main ScreenGui
	self.ScreenGui = CreateInstance("ScreenGui", {
		Name = "Da7muLibrary",
		IgnoreGuiInset = true,
		ScreenInsets = Enum.ScreenInsets.None,
		ResetOnSpawn = false,
		Parent = LocalPlayer:WaitForChild("PlayerGui")
	})

	-- Main Frame
	self.Main = CreateInstance("Frame", {
		Name = "Main",
		BackgroundColor3 = Color3.fromRGB(8, 8, 10),
		BackgroundTransparency = config.Transparent and 0.03 or 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = config.Size or UDim2.fromOffset(660, 525),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BorderSizePixel = 0,
		Parent = self.ScreenGui
	})

	CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = self.Main})

	-- Drop Shadow
	local DropShadowHolder = CreateInstance("Frame", {
		Name = "DropShadowHolder",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 0,
		Parent = self.Main
	})
	self.DropShadow = CreateInstance("ImageLabel", {
		Name = "DropShadow",
		Image = "rbxassetid://6014261993",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(1, 47, 1, 47),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1,
		ZIndex = 0,
		Parent = DropShadowHolder
	})

	-- TopBar
	self.TopBar = CreateInstance("Frame", {
		Name = "TopBar",
		BackgroundColor3 = Color3.fromRGB(8, 8, 10),
		BackgroundTransparency = 0.8,
		Size = UDim2.new(1, 0, 0, 60),
		BorderSizePixel = 0,
		Parent = self.Main
	})
	CreateInstance("UICorner", {Parent = self.TopBar})

	-- TopBar Title + Icon
	local TitleHolder = CreateInstance("Frame", {
		Name = "TitleHolder",
		BackgroundTransparency = 1,
		Size = UDim2.new(0.4, 0, 1, 0),
		Position = UDim2.new(0, 20, 0, 0),
		Parent = self.TopBar
	})
	self.WindowTitle = CreateInstance("TextLabel", {
		Name = "Title",
		Text = config.Title or "Da7mu Hub",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 18,
		FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Bold),
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -50, 1, 0),
		Parent = TitleHolder
	})
	if config.Icon then
		self.WindowIcon = CreateInstance("ImageLabel", {
			Name = "Icon",
			Image = config.Icon,
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(0, config.IconSize or 28, 0, config.IconSize or 28),
			Position = UDim2.new(0, 0, 0.5, -14),
			BackgroundTransparency = 1,
			Parent = TitleHolder
		})
	end

	-- Author
	if config.Author then
		CreateInstance("TextLabel", {
			Name = "Author",
			Text = config.Author,
			TextColor3 = Color3.fromRGB(156, 160, 164),
			TextSize = 12,
			FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, -18),
			Size = UDim2.new(1, 0, 0, 15),
			Parent = TitleHolder
		})
	end

	-- Close Button
	self.CloseButton = CreateInstance("ImageButton", {
		Name = "Close",
		Image = "rbxassetid://10734943674",
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(1, -30, 0.5, -10),
		BackgroundTransparency = 1,
		Parent = self.TopBar
	})
	self.CloseButton.MouseButton1Click:Connect(function()
		self.ScreenGui:Destroy()
	end)

	-- User Icon (optional)
	if config.User and config.User.Enabled then
		self.UserButton = CreateInstance("ImageButton", {
			Name = "User",
			Image = config.User.Anonymous and "rbxassetid://10734950309" or "rbxassetid://10734949999", -- anonymous / user icon
			Size = UDim2.new(0, 26, 0, 26),
			Position = UDim2.new(1, -70, 0.5, -13),
			BackgroundTransparency = 1,
			Parent = self.TopBar
		})
		self.UserButton.MouseButton1Click:Connect(config.User.Callback or function() end)
	end

	-- Navigation Sidebar
	self.Navigation = CreateInstance("Frame", {
		Name = "Navigation",
		BackgroundColor3 = Color3.fromRGB(21, 20, 25),
		BackgroundTransparency = 0.6,
		Size = UDim2.new(0, config.SideBarWidth or 200, 1, -60),
		Position = UDim2.new(0, 0, 0, 60),
		BorderSizePixel = 0,
		Parent = self.Main
	})
	CreateInstance("UICorner", {Parent = self.Navigation})

	self.ButtonHolder = CreateInstance("Frame", {
		Name = "ButtonHolder",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -20),
		Position = UDim2.new(0, 0, 0, 10),
		Parent = self.Navigation
	})
	CreateInstance("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = self.ButtonHolder})
	self.NavListLayout = CreateInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
		Parent = self.ButtonHolder
	})

	-- Content Container
	self.ContentContainer = CreateInstance("Frame", {
		Name = "ContentContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -(config.SideBarWidth or 200) - 12, 1, -72),
		Position = UDim2.new(1, -6, 0, 66),
		Parent = self.Main
	})

	-- Background Image
	if config.Background then
		self.BackgroundImage = CreateInstance("ImageLabel", {
			Name = "Background",
			Image = config.Background,
			ImageTransparency = config.BackgroundImageTransparency or 0.5,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Parent = self.Main
		})
		CreateInstance("UICorner", {CornerRadius = UDim.new(0, 12), Parent = self.BackgroundImage})
	end

	-- Dragging
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	self.TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = self.Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	self.TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then update(input) end
	end)

	-- Resizable (simple constraint)
	if config.Resizable then
		local sizeConstraint = CreateInstance("UISizeConstraint", {
			MinSize = config.MinSize or Vector2.new(560, 350),
			MaxSize = config.MaxSize or Vector2.new(850, 560),
			Parent = self.Main
		})
	end

	-- Store references
	self.NavButtons = {}
	self.TabContents = {}

	return self
end

-- Create Tab
function Da7mUI:CreateTab(config)
	local tab = {}
	tab.Name = config.Title or "Tab"
	tab.Icon = config.Icon or "rbxassetid://10723407389"

	-- Tab Button
	local isFirst = #self.Tabs == 0
	local button = CreateInstance("TextButton", {
		Name = isFirst and "Active" or "Inactive",
		Text = tab.Name,
		TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(177, 177, 177),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
		BackgroundColor3 = isFirst and Color3.fromRGB(31, 33, 36) or Color3.fromRGB(36, 36, 41),
		BackgroundTransparency = isFirst and 0.05 or 1,
		Size = UDim2.new(1, -14, 0, 38),
		BorderSizePixel = 0,
		Parent = self.ButtonHolder
	})
	CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = button})
	CreateInstance("UIPadding", {PaddingLeft = UDim.new(0, 40), Parent = button})

	local icon = CreateInstance("ImageLabel", {
		Name = "Icon",
		Image = tab.Icon,
		ImageColor3 = isFirst and Color3.fromRGB(36, 120, 255) or Color3.fromRGB(177, 177, 177),
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(0, -26, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		Parent = button
	})

	-- Content ScrollingFrame
	local content = CreateInstance("ScrollingFrame", {
		Name = tab.Name .. "Tab",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ScrollBarThickness = config.ScrollBarEnabled and 2 or 0,
		ScrollBarImageColor3 = Color3.fromRGB(36, 120, 255),
		BorderSizePixel = 0,
		Parent = self.ContentContainer,
		Visible = isFirst
	})
	CreateInstance("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		Parent = content
	})
	local listLayout = CreateInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 12),
		Parent = content
	})

	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
	end)

	-- Store
	self.Tabs[tab.Name] = tab
	self.NavButtons[tab.Name] = button
	self.TabContents[tab.Name] = content

	-- Click handler
	button.MouseButton1Click:Connect(function()
		self:SwitchTab(tab.Name)
	end)

	if isFirst then self.CurrentTab = tab.Name end

	-- Tab methods
	function tab:MultiSection(msConfig)
		-- MultiSection example implementation (segmented sub-sections)
		local section = self:CreateSection({Title = msConfig.Title or "Section", Box = msConfig.Box})

		-- Sub navigation inside section
		local subHolder = CreateInstance("Frame", {
			Name = "SubTabs",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 40),
			Parent = section.Content
		})
		local subList = CreateInstance("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), Parent = subHolder})

		local subContents = {}
		for i, sub in ipairs(msConfig.Sections or {}) do
			local subName, subIcon = sub[1], sub[2]
			local subBtn = CreateInstance("TextButton", {
				Text = subName,
				TextColor3 = Color3.fromRGB(177, 177, 177),
				BackgroundColor3 = Color3.fromRGB(36, 36, 41),
				Size = UDim2.new(0, 90, 0, 32),
				FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
				Parent = subHolder
			})
			CreateInstance("UICorner", {Parent = subBtn})

			local subContent = CreateInstance("Frame", {
				Name = subName,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -50),
				Visible = i == 1,
				Parent = section.Content
			})

			subContents[subName] = subContent
			subBtn.MouseButton1Click:Connect(function()
				for _, c in pairs(subContents) do c.Visible = false end
				subContent.Visible = true
			end)
		end

		section.SubContents = subContents
		return section
	end

	function tab:CreateSection(secConfig)
		local section = {}
		secConfig = secConfig or {}

		section.Frame = CreateInstance("Frame", {
			Name = secConfig.Title or "Section",
			BackgroundColor3 = Color3.fromRGB(17, 19, 22),
			BackgroundTransparency = secConfig.Box and 0.25 or 0,
			Size = UDim2.new(1, 0, 0, 40), -- will auto size
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			Parent = content
		})
		CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = section.Frame})
		if secConfig.BoxBorder then
			CreateInstance("UIStroke", {Color = Color3.fromRGB(29, 29, 33), Thickness = 1, Parent = section.Frame})
		end

		-- Section Title
		if secConfig.Title then
			section.TitleLabel = CreateInstance("TextLabel", {
				Name = "Title",
				Text = secConfig.Title:upper(),
				TextColor3 = Color3.fromRGB(156, 160, 164),
				TextSize = 12,
				FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.new(0, 12, 0, -12),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = section.Frame
			})
		end

		section.Content = CreateInstance("Frame", {
			Name = "Content",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = section.Frame
		})
		CreateInstance("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), Parent = section.Content})
		section.ListLayout = CreateInstance("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
			Parent = section.Content
		})

		section.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			-- auto height already handled by AutomaticSize
		end)

		-- Element methods
		function section:AddButton(btnConfig)
			local btn = CreateInstance("Frame", {
				Name = "Button",
				BackgroundColor3 = Color3.fromRGB(22, 21, 28),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 42),
				Parent = section.Content
			})
			CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})

			local title = CreateInstance("TextLabel", {
				Text = btnConfig.Title or "Button",
				TextColor3 = Color3.fromRGB(207, 207, 207),
				TextSize = 14,
				FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -30, 1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = btn
			})
			CreateInstance("UIPadding", {PaddingLeft = UDim.new(0, 12), Parent = title})

			local icon = CreateInstance("ImageLabel", {
				Image = btnConfig.Icon or "rbxassetid://10734898355",
				ImageColor3 = Color3.fromRGB(207, 207, 207),
				Size = UDim2.new(0, 20, 0, 20),
				Position = UDim2.new(1, -12, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 1,
				Parent = btn
			})

			btn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.7}):Play()
					task.delay(0.1, function()
						TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
					end)
					if btnConfig.Callback then btnConfig.Callback() end
				end
			end)

			return btn
		end

		function section:AddSlider(sliderConfig)
			local slider = CreateInstance("Frame", {
				Name = "Slider",
				BackgroundColor3 = Color3.fromRGB(22, 21, 28),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 52),
				Parent = section.Content
			})
			CreateInstance("UICorner", {CornerRadius = UDim.new(0, 6), Parent = slider})

			local title = CreateInstance("TextLabel", {
				Text = sliderConfig.Title or "Slider",
				TextColor3 = Color3.fromRGB(207, 207, 207),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -60, 0, 20),
				Position = UDim2.new(0, 12, 0, 8),
				Parent = slider
			})

			local valueLabel = CreateInstance("TextLabel", {
				Name = "Value",
				Text = tostring(sliderConfig.Default or 50),
				TextColor3 = Color3.fromRGB(207, 207, 207),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Right,
				FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json"),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 50, 0, 20),
				Position = UDim2.new(1, -12, 0, 8),
				Parent = slider
			})

			local bar = CreateInstance("Frame", {
				Name = "Bar",
				BackgroundColor3 = Color3.fromRGB(36, 36, 41),
				Size = UDim2.new(1, -24, 0, 6),
				Position = UDim2.new(0, 12, 0, 34),
				Parent = slider
			})
			CreateInstance("UICorner", {CornerRadius = UDim.new(0, 3), Parent = bar})

			local fill = CreateInstance("Frame", {
				Name = "Fill",
				BackgroundColor3 = Color3.fromRGB(36, 120, 255),
				Size = UDim2.new((sliderConfig.Default or 50) / 100, 0, 1, 0),
				Parent = bar
			})
			CreateInstance("UICorner", {CornerRadius = UDim.new(0, 3), Parent = fill})

			local knob = CreateInstance("Frame", {
				Name = "Knob",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Size = UDim2.new(0, 14, 0, 14),
				Position = UDim2.new((sliderConfig.Default or 50) / 100, -7, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Parent = bar
			})
			CreateInstance("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})

			-- Drag logic
			local min, max = sliderConfig.Min or 0, sliderConfig.Max or 100
			local dragging = false

			local function updateSlider(pos)
				local percent = math.clamp((pos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				local val = math.floor(min + (max - min) * percent)
				fill.Size = UDim2.new(percent, 0, 1, 0)
				knob.Position = UDim2.new(percent, -7, 0.5, 0)
				valueLabel.Text = tostring(val)
				if sliderConfig.Callback then sliderConfig.Callback(val) end
			end

			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					updateSlider(input.Position.X)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					updateSlider(input.Position.X)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)

			return slider
		end

		-- Add more elements (Dropdown, Toggle, etc.) can be added similarly...

		return section
	end

	return tab
end

function Da7mUI:SwitchTab(tabName)
	if self.CurrentTab == tabName then return end

	-- Deactivate old
	if self.CurrentTab and self.NavButtons[self.CurrentTab] then
		local oldBtn = self.NavButtons[self.CurrentTab]
		oldBtn.Name = "Inactive"
		oldBtn.BackgroundTransparency = 1
		oldBtn.TextColor3 = Color3.fromRGB(177, 177, 177)
		oldBtn.Icon.ImageColor3 = Color3.fromRGB(177, 177, 177)
		self.TabContents[self.CurrentTab].Visible = false
	end

	-- Activate new
	local newBtn = self.NavButtons[tabName]
	if newBtn then
		newBtn.Name = "Active"
		newBtn.BackgroundTransparency = 0.05
		newBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		newBtn.Icon.ImageColor3 = Color3.fromRGB(36, 120, 255)
		self.TabContents[tabName].Visible = true
	end

	self.CurrentTab = tabName
end

return Da7mUI
