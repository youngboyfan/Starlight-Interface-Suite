--[[
	Starlight Interface Suite — Enhanced Example
	=============================================
	
	USAGE:
	Option A — Run as a standalone script (loads from local file):
		local Starlight = loadstring(game:GetObjects("rbxassetid://132866968194043")[1].Source.Value)()
		-- then run this example below
		
	Option B — Add this code to the Testing section of Source.lua
		(inside the `if isStudio and enabled then` block, around line 12510)
	
	DEMONSTRATES:
	✓  New themes (Starlight:SetTheme)
	✓  Toast notifications (Starlight:Toast)
	✓  Command Palette (Ctrl+K — built-in)
	✓  Quick Settings Panel (Ctrl+Q — built-in)
	✓  New elements: Progress, SegmentedControl, Badge
	✓  New API: Starlight:SearchElements, win:OnTabChange
	✓  Acrylic intensity (Starlight:SetAcrylicIntensity)
]]

--[[ === PASTE THIS INSIDE Source.lua's Testing section (line ~12510) ===

Replace the existing test code with this, or add it after the existing tests.
The internal variables (mainAcrylic, acrylicEvent) are only accessible from 
within Source.lua's scope, so some features require running inside the Testing 
section rather than externally.
]]

-- Reset for clean demo
Starlight:SetTheme("Tokyo Night Storm")

local win = Starlight:CreateWindow({
	Name = "Starlight Enhanced",
	Subtitle = "feat. all new improvements",
	Icon = 92936499827985,

	LoadingEnabled = false,
	BuildWarnings = false,
	NotifyOnCallbackError = true,

	KeySystem = {
		Enabled = false,
	},
})

-- Home tab
win:CreateHomeTab({
	Backdrop = 78881404248017,
})

-- =====================
-- TAB: New Features
-- =====================
local featSection = win:CreateTabSection("✦ NEW FEATURES")

local featTab = featSection:CreateTab({
	Name = "Toasts & Actions",
	Columns = 2,
}, "feat_tab")

-- TOAST EXAMPLES
local toastGB = featTab:CreateGroupbox({
	Name = "Toast Notifications",
	Column = 1,
}, "toast_gb")

toastGB:CreateButton({
	Name = "Info Toast",
	Callback = function()
		Starlight:Toast({
			Title = "Information",
			Content = "Standard info toast with blue accent.",
			Intent = "info",
			Duration = 3,
		})
	end,
})

toastGB:CreateButton({
	Name = "Success Toast",
	Callback = function()
		Starlight:Toast({
			Title = "Operation Complete",
			Content = "Your action was successful!",
			Intent = "success",
			Duration = 3,
		})
	end,
})

toastGB:CreateButton({
	Name = "Warning Toast",
	Callback = function()
		Starlight:Toast({
			Title = "Warning",
			Content = "This action may have side effects.",
			Intent = "warning",
			Duration = 4,
		})
	end,
})

toastGB:CreateButton({
	Name = "Error Toast",
	Callback = function()
		Starlight:Toast({
			Title = "Error Occurred",
			Content = "Something went wrong. Try again.",
			Intent = "error",
			Duration = 4,
		})
	end,
})

toastGB:CreateDivider()

toastGB:CreateButton({
	Name = "Stack 5 Toasts (Stress Test)",
	Tooltip = "Shows auto-stacking and max cap behavior",
	Callback = function()
		for i = 1, 5 do
			task.delay(i * 0.3, function()
				Starlight:Toast({
					Title = "Toast #" .. i,
					Content = "Stacking demo — caps at 5 visible toasts.",
					Intent = i == 5 and "error" or "info",
					Duration = 8,
				})
			end)
		end
	end,
})

-- ACTIONS
local actionGB = featTab:CreateGroupbox({
	Name = "Quick Actions",
	Column = 2,
}, "action_gb")

actionGB:CreateButton({
	Name = "Search All Elements",
	Tooltip = "Searches every tab for 'Button'",
	Callback = function()
		local results = Starlight:SearchElements("Button")
		Starlight:Toast({
			Title = "Found " .. #results .. " results",
			Content = #results > 0 and ('First: "' .. results[1].Element.Values.Name .. '"') or "No matches",
			Intent = "info",
			Duration = 4,
		})
	end,
})

actionGB:CreateButton({
	Name = "Toggle Acrylic Blur",
	Tooltip = "Enables/disables the frosted glass effect",
	Callback = function()
		mainAcrylic = not mainAcrylic
		acrylicEvent:Fire()
		Starlight:Toast({
			Title = "Acrylic " .. (mainAcrylic and "Enabled" or "Disabled"),
			Intent = "info",
			Duration = 2,
		})
	end,
})

actionGB:CreateButton({
	Name = "Acrylic: 25%",
	Tooltip = "Subtle blur",
	Callback = function()
		Starlight:SetAcrylicIntensity(0.25)
		Starlight:Toast({ Title = "Acrylic: 25%", Intent = "info", Duration = 2 })
	end,
})

actionGB:CreateButton({
	Name = "Acrylic: 100%",
	Tooltip = "Full blur",
	Callback = function()
		Starlight:SetAcrylicIntensity(1)
		Starlight:Toast({ Title = "Acrylic: 100%", Intent = "info", Duration = 2 })
	end,
})

actionGB:CreateDivider()

actionGB:CreateLabel({
	Name = "Shortcuts:  Ctrl+K  ·  Ctrl+Q",
})

-- =====================
-- TAB: New Elements
-- =====================
local elemTab = featSection:CreateTab({
	Name = "New Elements",
	Columns = 2,
}, "elem_tab")

-- PROGRESS
local progGB = elemTab:CreateGroupbox({
	Name = "Progress Bar",
	Column = 1,
}, "prog_gb")

local prog = progGB:CreateProgress({
	Name = "Download Progress",
	CurrentValue = 0,
	ShowLabel = true,
}, "prog_demo")

local progVal = 0
progGB:CreateButton({
	Name = "Animate 0→100%",
	Callback = function()
		progVal = 0
		for i = 1, 100 do
			task.delay(i * 0.025, function()
				progVal = i / 100
				prog:Set({ CurrentValue = progVal })
			end)
		end
		task.delay(2.6, function()
			Starlight:Toast({ Title = "Animation Complete!", Intent = "success", Duration = 2 })
		end)
	end,
})

progGB:CreateButton({
	Name = "Reset",
	Callback = function()
		progVal = 0
		prog:Set({ CurrentValue = 0 })
	end,
})

-- SEGMENTED CONTROL
local segGB = elemTab:CreateGroupbox({
	Name = "Segmented Control",
	Column = 1,
}, "seg_gb")

segGB:CreateLabel({ Name = "Selection: View A" }, "seg_status")

local segCtrl = segGB:CreateSegmentedControl({
	Name = "View Mode",
	Options = { "View A", "View B", "View C" },
	CurrentOption = "View A",
	Callback = function(opt)
		local label = Starlight.Window.TabSections["✦ NEW FEATURES"].Tabs["elem_tab"].Groupboxes["seg_gb"].Elements["seg_status"]
		if label and label.Set then
			label:Set({ Name = "Selection: " .. opt })
		end
	end,
}, "seg_ctrl")

-- BADGES
local badgeGB = elemTab:CreateGroupbox({
	Name = "Badges & Chips",
	Column = 2,
}, "badge_gb")

badgeGB:CreateBadge({ Name = "Status", Text = "Online", Color = Color3.fromRGB(80, 200, 120) }, "b1")
badgeGB:CreateBadge({ Name = "Tag", Text = "Premium", Color = Color3.fromRGB(230, 180, 60) }, "b2")
badgeGB:CreateBadge({ Name = "Version", Text = "v2.1.0", Color = Color3.fromRGB(86, 156, 214) }, "b3")
badgeGB:CreateBadge({ Name = "Env", Text = "Production", Color = Color3.fromRGB(189, 147, 249) }, "b4")

badgeGB:CreateDivider()

local badgeN = 0
badgeGB:CreateButton({
	Name = "Add Removable Badge",
	Callback = function()
		badgeN += 1
		badgeGB:CreateBadge({
			Name = "Temp",
			Text = "Click × to dismiss",
			Color = Color3.fromRGB(255, 85, 85),
			Removable = true,
			Callback = function()
				Starlight:Toast({ Title = "Badge Removed", Intent = "info", Duration = 2 })
			end,
		}, "tmp_" .. badgeN)
	end,
})

-- API EVENTS
local apiGB = elemTab:CreateGroupbox({
	Name = "Tab Change Events",
	Column = 2,
}, "api_gb")

apiGB:CreateLabel({ Name = "win:OnTabChange(callback)" }, "api_l1")
apiGB:CreateLabel({ Name = "Fires when you switch tabs" }, "api_l2")

win:OnTabChange(function(tab)
	Starlight:Toast({
		Title = "Switched to: " .. (tab.Values and tab.Values.Name or "Home"),
		Intent = "info",
		Duration = 2,
	})
end)

-- =====================
-- TAB: Theme Switcher
-- =====================
local themeSection = win:CreateTabSection("🎨 THEMES")

local themeTab = themeSection:CreateTab({
	Name = "Quick Switch",
	Columns = 2,
}, "theme_tab")

local themeNames = {
	"Starlight", "Hollywood Dark", "Orca", "Nord", "Dracula",
	"Tokyo Night Storm", "Catppuccin Mocha", "Rose Pine",
	"Aurora", "Glacier", "VSCode Dark Modern",
}

for i, name in ipairs(themeNames) do
	local col = i <= math.ceil(#themeNames / 2) and 1 or 2
	local gb = themeTab:CreateGroupbox({
		Name = name,
		Column = col,
		Style = 2,
	}, "th_" .. i)

	gb:CreateButton({
		Name = "Apply",
		Callback = function()
			Starlight:SetTheme(name)
			Starlight:Toast({
				Title = "Theme: " .. name,
				Content = "Theme applied. Press Ctrl+K to search themes.",
				Intent = "success",
				Duration = 2,
			})
		end,
	})
end

-- =====================
-- Finalize
-- =====================
Starlight:LoadAutoloadConfig()

-- Welcome message
task.delay(1, function()
	Starlight:Toast({
		Title = "Welcome to Starlight Enhanced!",
		Content = "Ctrl+K = Commands · Ctrl+Q = Settings · 7 new themes · Toasts · New elements",
		Intent = "info",
		Duration = 6,
	})
end)
