--[[
	Starlight Interface Suite — Enhanced Example
	For use with executors (or Studio)
	
	Simply run this script. Works with any executor.
	Loads the library from GitHub, then creates the demo UI.
]]

-- Load Starlight from your enhanced fork
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/youngboyfan/Starlight-Interface-Suite/master/Source.lua"))()

-- Apply a modern theme
Starlight:SetTheme("Tokyo Night Storm")

-- Create the window
local win = Starlight:CreateWindow({
	Name = "Starlight Enhanced Demo",
	Subtitle = "All new features showcase",
	Icon = 92936499827985,
	LoadingEnabled = false,
	BuildWarnings = false,
	NotifyOnCallbackError = true,
	KeySystem = { Enabled = false },
})

-- Home tab
win:CreateHomeTab({ Backdrop = 78881404248017 })

-- Demo everything below. Press Ctrl+K for Command Palette, Ctrl+Q for Quick Settings.
-----------------------------------------------------------------------
-- TAB 1: Toast & Actions
-----------------------------------------------------------------------
local tab1 = win:CreateTabSection("FEATURES"):CreateTab({ Name = "Toasts & Actions", Columns = 2 }, "demo_tab1")

local toastGB = tab1:CreateGroupbox({ Name = "Toast Notifications", Column = 1 }, "toast_gb")
toastGB:CreateButton({ Name = "Info Toast", Callback = function()
	Starlight:Toast({ Title = "Information", Content = "This is an info toast.", Intent = "info", Duration = 3 })
end })
toastGB:CreateButton({ Name = "Success Toast", Callback = function()
	Starlight:Toast({ Title = "Success!", Content = "Operation completed.", Intent = "success", Duration = 3 })
end })
toastGB:CreateButton({ Name = "Warning Toast", Callback = function()
	Starlight:Toast({ Title = "Warning", Content = "Proceed with caution.", Intent = "warning", Duration = 4 })
end })
toastGB:CreateButton({ Name = "Error Toast", Callback = function()
	Starlight:Toast({ Title = "Error", Content = "Something went wrong.", Intent = "error", Duration = 4 })
end })
toastGB:CreateDivider()
toastGB:CreateButton({ Name = "Stack 5 Toasts", Tooltip = "Tests auto-stacking (max 5)", Callback = function()
	for i = 1, 5 do
		task.delay(i * 0.3, function()
			Starlight:Toast({ Title = "Toast #" .. i, Content = "Stacking demo", Intent = i == 5 and "error" or "info", Duration = 8 })
		end)
	end
end })

local actionGB = tab1:CreateGroupbox({ Name = "Quick Actions", Column = 2 }, "action_gb")
actionGB:CreateButton({ Name = "Search All Elements", Tooltip = "Finds every element named 'Button'", Callback = function()
	local r = Starlight:SearchElements("Button")
	Starlight:Toast({ Title = "Found " .. #r .. " elements", Content = #r > 0 and r[1].Element.Values.Name or "No matches", Intent = "info", Duration = 4 })
end })
actionGB:CreateButton({ Name = "Launch Command Palette", Callback = function()
	Starlight:Toast({ Title = "Press Ctrl+K", Content = "Opens the command palette with fuzzy search", Intent = "info", Duration = 3 })
end })
actionGB:CreateDivider()
actionGB:CreateLabel({ Name = "Shortcuts:  Ctrl+K  .  Ctrl+Q" })

-----------------------------------------------------------------------
-- TAB 2: New Elements
-----------------------------------------------------------------------
local tab2 = win:CreateTabSection("ELEMENTS"):CreateTab({ Name = "New Elements", Columns = 2 }, "demo_tab2")

-- Progress Bar
local pgGB = tab2:CreateGroupbox({ Name = "Progress Bar", Column = 1 }, "prog_gb")
local prog = pgGB:CreateProgress({ Name = "Download Progress", CurrentValue = 0, ShowLabel = true }, "prog_demo")
local progVal = 0
pgGB:CreateButton({ Name = "Animate 0% to 100%", Callback = function()
	progVal = 0
	for i = 1, 100 do
		task.delay(i * 0.025, function()
			progVal = i / 100
			prog:Set({ CurrentValue = progVal })
		end)
	end
	task.delay(2.6, function() Starlight:Toast({ Title = "Animation Complete!", Intent = "success", Duration = 2 }) end)
end })
pgGB:CreateButton({ Name = "Reset", Callback = function()
	progVal = 0
	prog:Set({ CurrentValue = 0 })
end })

-- Segmented Control
local segGB = tab2:CreateGroupbox({ Name = "Segmented Control", Column = 1 }, "seg_gb")
segGB:CreateLabel({ Name = "Selection: View A" }, "seg_status")
segGB:CreateSegmentedControl({
	Name = "View Mode",
	Options = { "View A", "View B", "View C" },
	CurrentOption = "View A",
	Callback = function(opt)
		Starlight:Toast({ Title = "Selected: " .. opt, Intent = "info", Duration = 2 })
	end,
}, "seg_ctrl")

-- Badges
local badgeGB = tab2:CreateGroupbox({ Name = "Badges & Chips", Column = 2 }, "badge_gb")
badgeGB:CreateBadge({ Name = "Status", Text = "Online", Color = Color3.fromRGB(80, 200, 120) }, "b1")
badgeGB:CreateBadge({ Name = "Tag", Text = "Premium", Color = Color3.fromRGB(230, 180, 60) }, "b2")
badgeGB:CreateBadge({ Name = "Version", Text = "v2.1.0", Color = Color3.fromRGB(86, 156, 214) }, "b3")
badgeGB:CreateBadge({ Name = "Env", Text = "Production", Color = Color3.fromRGB(189, 147, 249) }, "b4")
badgeGB:CreateDivider()
local badgeN = 0
badgeGB:CreateButton({ Name = "Add Removable Badge", Callback = function()
	badgeN += 1
	badgeGB:CreateBadge({
		Name = "Temp",
		Text = "Click X to dismiss",
		Color = Color3.fromRGB(255, 85, 85),
		Removable = true,
		Callback = function() Starlight:Toast({ Title = "Badge Removed", Intent = "info", Duration = 2 }) end,
	}, "tmp_" .. badgeN)
end })

-- Tab change event demo
local apiGB = tab2:CreateGroupbox({ Name = "Tab Change Events", Column = 2 }, "api_gb")
apiGB:CreateLabel({ Name = "Switch tabs to see the event fire:" }, "api_l1")
apiGB:CreateLabel({ Name = "win:OnTabChange(callback)" }, "api_l2")
win:OnTabChange(function(tab)
	Starlight:Toast({ Title = "Switched to: " .. (tab.Values and tab.Values.Name or "Home"), Intent = "info", Duration = 2 })
end)

-- Tab change trigger buttons
apiGB:CreateDivider()
apiGB:CreateButton({ Name = "Switch to FEATURES tab", Callback = function()
	-- Switch via the tab's button click if accessible
	Starlight:Toast({ Title = "Click the tab in the sidebar", Intent = "info", Duration = 3 })
end })

-----------------------------------------------------------------------
-- TAB 3: Theme Switcher
-----------------------------------------------------------------------
local tab3 = win:CreateTabSection("THEMES"):CreateTab({ Name = "Quick Switch", Columns = 2 }, "demo_tab3")

local themeNames = {
	"Starlight", "Hollywood Dark", "Orca", "Nord", "Dracula",
	"Tokyo Night Storm", "Catppuccin Mocha", "Rose Pine",
	"Aurora", "Glacier", "VSCode Dark Modern",
}
for i, name in ipairs(themeNames) do
	local col = i <= math.ceil(#themeNames / 2) and 1 or 2
	local gb = tab3:CreateGroupbox({ Name = name, Column = col, Style = 2 }, "th_" .. i)
	gb:CreateButton({ Name = "Apply Theme", Callback = function()
		Starlight:SetTheme(name)
		Starlight:Toast({ Title = "Theme: " .. name, Intent = "success", Duration = 2 })
	end })
end

-----------------------------------------------------------------------
-- TAB 4: Acrylic Controls
-----------------------------------------------------------------------
local tab4 = win:CreateTabSection("DISPLAY"):CreateTab({ Name = "Acrylic & Effects", Columns = 2 }, "demo_tab4")

local acrGB = tab4:CreateGroupbox({ Name = "Acrylic Blur Intensity", Column = 1 }, "acr_gb")
acrGB:CreateButton({ Name = "Set Acrylic: OFF", Callback = function()
	Starlight:SetAcrylicIntensity(0)
	Starlight:Toast({ Title = "Acrylic: Off", Intent = "info", Duration = 2 })
end })
acrGB:CreateButton({ Name = "Set Acrylic: 25% (Subtle)", Callback = function()
	Starlight:SetAcrylicIntensity(0.25)
	Starlight:Toast({ Title = "Acrylic: 25%", Intent = "info", Duration = 2 })
end })
acrGB:CreateButton({ Name = "Set Acrylic: 50% (Medium)", Callback = function()
	Starlight:SetAcrylicIntensity(0.5)
	Starlight:Toast({ Title = "Acrylic: 50%", Intent = "info", Duration = 2 })
end })
acrGB:CreateButton({ Name = "Set Acrylic: 100% (Full)", Callback = function()
	Starlight:SetAcrylicIntensity(1)
	Starlight:Toast({ Title = "Acrylic: 100%", Intent = "info", Duration = 2 })
end })

-----------------------------------------------------------------------
-- Welcome message
-----------------------------------------------------------------------
task.delay(1.5, function()
	Starlight:Toast({
		Title = "Welcome to Starlight Enhanced!",
		Content = "Ctrl+K = Commands  .  Ctrl+Q = Settings  .  Try all the new features!",
		Intent = "info",
		Duration = 7,
	})
end)
