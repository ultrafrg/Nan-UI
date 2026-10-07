--[[
    NAN UI v1.0
    updated
]]

local NAN = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Themes = {
    Ocean = {
        Background = Color3.fromRGB(18, 22, 30),
        Secondary = Color3.fromRGB(24, 30, 40),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(240, 240, 240),
        Muted = Color3.fromRGB(150, 155, 165)
    },

    Dark = {
        Background = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(120, 120, 255),
        Text = Color3.fromRGB(245, 245, 245),
        Muted = Color3.fromRGB(150, 150, 150)
    }
}

local function Create(class, properties, parent)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    if parent then
        object.Parent = parent
    end

    return object
end

local function Corner(parent, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6)
    }, parent)
end

local function MakeDraggable(frame, handle)

    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)

        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
    end)

    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function NAN:CreateWindow(config)

    config = config or {}

    local Theme = Themes[config.Theme or "Ocean"] or Themes.Ocean
    local Title = config.Title or "NAN UI"

    local GUI = Create("ScreenGui", {
        Name = "NAN_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, PlayerGui)

    -- Fixed centering
    local Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0
    }, GUI)

    Corner(Main, 10)

    local TopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0
    }, Main)

    Corner(TopBar, 10)

    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    }, TopBar)

    local Close = Create("TextButton", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -45, 0, 0),
        Size = UDim2.new(0, 45, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 24
    }, TopBar)

    local Sidebar = Create("ScrollingFrame", {
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 150, 1, -45),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, Main)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8)
    }, Sidebar)

    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Sidebar)

    local Content = Create("Frame", {
        Position = UDim2.new(0, 150, 0, 45),
        Size = UDim2.new(1, -150, 1, -45),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    }, Main)

    local Window = {}
    local FirstTab = true

    MakeDraggable(Main, TopBar)

    Close.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)

    function Window:CreateTab(name)

        local TabButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Theme.Muted,
            TextSize = 13
        }, Sidebar)

        Corner(TabButton, 6)

        local Page = Create("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = FirstTab,
            ScrollBarThickness = 4,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, Content)

        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, Page)

        if FirstTab then
            TabButton.TextColor3 = Theme.Accent
            FirstTab = false
        end

        local Tab = {}

        TabButton.MouseButton1Click:Connect(function()

            for _, child in ipairs(Content:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end

            for _, child in ipairs(Sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = Theme.Muted
                end
            end

            Page.Visible = true
            TabButton.TextColor3 = Theme.Accent
        end)

        function Tab:CreateSection(name)

            local SectionFrame = Create("Frame", {
                Size = UDim2.new(1, -5, 0, 0),
                BackgroundColor3 = Theme.Secondary,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y
            }, Page)

            Corner(SectionFrame, 7)

            Create("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            }, SectionFrame)

            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                Text = name,
                TextColor3 = Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            }, SectionFrame)

            local Container = Create("Frame", {
                Position = UDim2.new(0, 0, 0, 30),
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y
            }, SectionFrame)

            Create("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, Container)

            local Section = {}

            function Section:CreateLabel(text)

                return Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Theme.Muted,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, Container)
            end

            function Section:CreateButton(text, callback)

                local Button = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.Background,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = Theme.Text,
                    TextSize = 13
                }, Container)

                Corner(Button, 6)

                Button.MouseButton1Click:Connect(function()
                    if callback then
                        callback()
                    end
                end)

                return Button
            end

            function Section:CreateToggle(text, options)

                options = options or {}

                local enabled = options.Default == true

                local Toggle = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Theme.Background,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    Text = text .. "  [" ..
                        (enabled and "ON" or "OFF") .. "]",
                    TextColor3 = Theme.Text,
                    TextSize = 13
                }, Container)

                Corner(Toggle, 6)

                Toggle.MouseButton1Click:Connect(function()

                    enabled = not enabled

                    Toggle.Text = text .. "  [" ..
                        (enabled and "ON" or "OFF") .. "]"

                    if options.Callback then
                        options.Callback(enabled)
                    end
                end)

                return Toggle
            end

            function Section:CreateSlider(text, options)

                options = options or {}

                local Min = tonumber(options.Min) or 0
                local Max = tonumber(options.Max) or 100

                if Max <= Min then
                    Max = Min + 1
                end

                local Value = math.clamp(
                    tonumber(options.Default) or Min,
                    Min,
                    Max
                )

                local Holder = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 55),
                    BackgroundTransparency = 1
                }, Container)

                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham,
                    Text = text .. ": " .. tostring(Value),
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, Holder)

                local Bar = Create("TextButton", {
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 8),
                    BackgroundColor3 = Theme.Background,
                    BorderSizePixel = 0,
                    Text = ""
                }, Holder)

                Corner(Bar, 4)

                local Fill = Create("Frame", {
                    Size = UDim2.new(
                        (Value - Min) / (Max - Min),
                        0,
                        1,
                        0
                    ),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0
                }, Bar)

                Corner(Fill, 4)

                local function SetValue(x)

                    local width = Bar.AbsoluteSize.X

                    if width <= 0 then
                        return
                    end

                    local percent = math.clamp(
                        (x - Bar.AbsolutePosition.X) / width,
                        0,
                        1
                    )

                    Value = math.floor(
                        Min + ((Max - Min) * percent) + 0.5
                    )

                    Fill.Size = UDim2.new(
                        percent,
                        0,
                        1,
                        0
                    )

                    Label.Text = text .. ": " .. tostring(Value)

                    if options.Callback then
                        options.Callback(Value)
                    end
                end

                local dragging = false

                Bar.InputBegan:Connect(function(input)

                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then

                        dragging = true
                        SetValue(input.Position.X)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)

                    if dragging and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    ) then

                        SetValue(input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)

                    if input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch then

                        dragging = false
                    end
                end)

                return Holder
            end

            return Section
        end

        return Tab
    end

    function Window:Notify(message, duration)

        duration = tonumber(duration) or 3

        local Notification = Create("TextLabel", {
            Size = UDim2.new(0, 260, 0, 45),
            Position = UDim2.new(1, -275, 1, -60),
            BackgroundColor3 = Theme.Secondary,
            BorderSizePixel = 0,
            Font = Enum.Font.Gotham,
            Text = tostring(message),
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextWrapped = true
        }, GUI)

        Corner(Notification, 8)

        task.delay(duration, function()
            if Notification and Notification.Parent then
                Notification:Destroy()
            end
        end)
    end

    return Window
end

return NAN
