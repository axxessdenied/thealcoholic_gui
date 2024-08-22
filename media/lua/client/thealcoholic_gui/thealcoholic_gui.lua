-- (c) 2024 - axxessdenied [Nick Slusarczyk]

TheAlcoholic.UI = {}
TheAlcoholic.UI.playerWindow = {}
TheAlcoholic.UI.statsWindow = {}
TheAlcoholic.UI.visible = false

TheAlcoholic.UI.player_cache = {}

local function refreshStats()
    TheAlcoholic.UI.statsWindow["stress"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicStress))
    TheAlcoholic.UI.statsWindow["tolerance"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicTolerance))
    TheAlcoholic.UI.statsWindow["threshold"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicThreshold))
    TheAlcoholic.UI.statsWindow["withdrawal"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicWithdrawalSickness))
    TheAlcoholic.UI.statsWindow["tolerance_penalty"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicTolerancePenalty))
    TheAlcoholic.UI.statsWindow["poison"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicPoisonDamageTotal))
    TheAlcoholic.UI.statsWindow["time_since_last_drink"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicTimeSinceLastDrink))
    TheAlcoholic.UI.statsWindow["drinks_per_day"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicDrinksPerDay))
    TheAlcoholic.UI.statsWindow["drinks_total"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicDrinksTotal))
    TheAlcoholic.UI.statsWindow["has_withdrawal_sickness"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicHasWithdrawalSickness))
    TheAlcoholic.UI.statsWindow["withdrawal_phase"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicWithdrawalPhase))
    TheAlcoholic.UI.statsWindow["has_drank"]:setText(tostring(TheAlcoholic.UI.player_cache:getModData().AlcoholicHasDrank))
end

local function openStats(_, player)
    local playerObj = getSpecificPlayer(player)

    if playerObj == nil then
        return
    end

    TheAlcoholic.UI.player_cache = playerObj
    refreshStats()
    TheAlcoholic.UI.statsWindow:setPositionPixel(TheAlcoholic.UI.playerWindow:getX(), TheAlcoholic.UI.playerWindow:getY() + TheAlcoholic.UI.playerWindow:getHeight())
    TheAlcoholic.UI.statsWindow:open()
end

local function closeStats()
    TheAlcoholic.UI.statsWindow:close()
end

local function updatePlayers()
    if TheAlcoholic.UI.visible == true
    then
        local player1 = getSpecificPlayer(0)
        local player2 = getSpecificPlayer(1)
        local player3 = getSpecificPlayer(2)
        local player4 = getSpecificPlayer(3)

        local player1_str = "Player 1"
        local player2_str = "Player 2"
        local player3_str = "Player 3"
        local player4_str = "Player 4"

        if player1 then
            player1_str = player1:getForname().." "..player1:getSurname()
        end

        if player2 then
            player2_str = player2:getForname().." "..player2:getSurname()
        end

        if player3 then
            player3_str = player3:getForname().." "..player3:getSurname()
        end

        if player4 then
            player4_str = player4:getForname().." "..player4:getSurname()
        end

        TheAlcoholic.UI.playerWindow["list"]:setItems({ [player1_str] = 0, [player2_str] = 1, [player3_str] = 2, [player4_str] = 3 })
    end
end

local function toggleAlcoholicGUI()
    TheAlcoholic.UI.visible = not TheAlcoholic.UI.visible
    updatePlayers()
    TheAlcoholic.UI.playerWindow:toggle()
end

local function refresh_button_click()
    TheAlcoholic.UI.statsWindow:close()
    refreshStats()
    TheAlcoholic.UI.statsWindow:open()
end

local function onCreateUI()
    local players = {} 
    for i=0, 3 do
        local player_str = "Player "..(i+1)
        players[player_str] = i
    end
    TheAlcoholic.UI.playerWindow = NewUI()
    TheAlcoholic.UI.playerWindow:setTitle("The Alcoholic: Local players")
    TheAlcoholic.UI.playerWindow:setWidthPercent(0.10)
    TheAlcoholic.UI.playerWindow:setPositionPercent(0.05, 0.25)
    TheAlcoholic.UI.playerWindow:addScrollList("list", players)
    TheAlcoholic.UI.playerWindow:nextLine()
    TheAlcoholic.UI.playerWindow:addButton("close_button", "Close", toggleAlcoholicGUI)
    TheAlcoholic.UI.playerWindow:setCollapse(true)

    TheAlcoholic.UI.playerWindow["list"]:setOnMouseDownFunction(_, openStats)

    TheAlcoholic.UI.playerWindow:saveLayout()

    TheAlcoholic.UI.statsWindow = NewUI()
    TheAlcoholic.UI.statsWindow:setTitle("Player Alcoholic Stats")
    TheAlcoholic.UI.statsWindow:isSubUIOf(TheAlcoholic.UI.playerWindow)
    TheAlcoholic.UI.statsWindow:setWidthPercent(0.10)
    TheAlcoholic.UI.statsWindow:setCollapse(true)

    TheAlcoholic.UI.statsWindow:setDefaultLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("AlcoholicStressLevel", "Alcoholic Stress Level: ")
    TheAlcoholic.UI.statsWindow["AlcoholicStressLevel"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("stress", "")
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:nextLine()
    
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("AlcoholicTolerance", "Alcoholic Tolerance: ")
    TheAlcoholic.UI.statsWindow["AlcoholicTolerance"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("tolerance", "")
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("AlcoholicThreshold", "Alcoholic Threshold: ")
    TheAlcoholic.UI.statsWindow["AlcoholicThreshold"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("threshold", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("AlcoholicTolerancePenalty", "Alcoholic Tolerance Penalty: ")
    TheAlcoholic.UI.statsWindow["AlcoholicTolerancePenalty"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("tolerance_penalty", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("AlcoholicPoisonLevel", "Alcoholic Poison Level: ")
    TheAlcoholic.UI.statsWindow["AlcoholicPoisonLevel"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("poison", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("TimeSinceLastDrink", "Time Since Last Drink: ")
    TheAlcoholic.UI.statsWindow["TimeSinceLastDrink"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("time_since_last_drink", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("AlcoholicDrinksToday", "Alcoholic Drinks Today: ")
    TheAlcoholic.UI.statsWindow["AlcoholicDrinksToday"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("drinks_per_day", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("AlcoholicDrinksTotal", "Alcoholic Drinks Total: ")
    TheAlcoholic.UI.statsWindow["AlcoholicDrinksTotal"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("drinks_total", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("WithdrawalPhase", "Withdrawal Phase: ")
    TheAlcoholic.UI.statsWindow["WithdrawalPhase"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("withdrawal_phase", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("HasWithdrawalSickness", "Has Withdrawal Sickness: ")
    TheAlcoholic.UI.statsWindow["HasWithdrawalSickness"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("has_withdrawal_sickness", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("WithdrawalSickness", "Withdrawal Sickness: ")
    TheAlcoholic.UI.statsWindow["WithdrawalSickness"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("withdrawal", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("HasDrankAlcohol", "Has Drank Alcohol Last Hour: ")
    TheAlcoholic.UI.statsWindow["HasDrankAlcohol"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("has_drank", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addButton("refresh_button", "Refresh", refresh_button_click)
    TheAlcoholic.UI.statsWindow:nextLine()   
    TheAlcoholic.UI.statsWindow:addButton("close_button", "Close", closeStats)
    TheAlcoholic.UI.statsWindow:addButton("close_all", "Close All", toggleAlcoholicGUI)
    TheAlcoholic.UI.statsWindow:saveLayout()
    TheAlcoholic.UI.statsWindow:close()
    TheAlcoholic.UI.playerWindow:close()
end

function TheAlcoholic.UI.onRightClick(player, context, items)
    items = ISInventoryPane.getActualItems(items)
    local has_displayed = false
    for _, item in ipairs(items) do
        if item then
            if item:isAlcoholic() == true and has_displayed == false
            then
                context:addOption("Show Alcoholic Stats", player, toggleAlcoholicGUI, item)
                has_displayed = true
            end
        end
    end
end

Events.OnCreateUI.Add(onCreateUI)
Events.OnFillInventoryObjectContextMenu.Add(TheAlcoholic.UI.onRightClick)