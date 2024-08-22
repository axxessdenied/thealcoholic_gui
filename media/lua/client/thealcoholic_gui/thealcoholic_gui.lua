local playerWindow
local statsWindow
local visible = false

local players = {}

for i=0, getNumActivePlayers() - 1 do
    local player = getSpecificPlayer(i)
    local player_str = "Player "
    print ("Alcohol GUI - Player: " .. player_str)
    players[player_str] = i
end



local function openStats(_, player)
    local playerObj = getSpecificPlayer(player)

    statsWindow["stress"]:setText(tostring(playerObj:getModData().AlcoholicStress))
    statsWindow["tolerance"]:setText(tostring(playerObj:getModData().AlcoholicTolerance))
    statsWindow["threshold"]:setText(tostring(playerObj:getModData().AlcoholicThreshold))
    statsWindow["withdrawal"]:setText(tostring(playerObj:getModData().AlcoholicWithdrawalSickness))
    statsWindow["tolerance_penalty"]:setText(tostring(playerObj:getModData().AlcoholicTolerancePenalty))
    statsWindow["poison"]:setText(tostring(playerObj:getModData().AlcoholicPoisonDamageTotal))
    statsWindow["time_since_last_drink"]:setText(tostring(playerObj:getModData().AlcoholicTimeSinceLastDrink))
    statsWindow["drinks_per_day"]:setText(tostring(playerObj:getModData().AlcoholicDrinksPerDay))
    statsWindow["drinks_total"]:setText(tostring(playerObj:getModData().AlcoholicDrinksTotal))
    statsWindow["has_withdrawal_sickness"]:setText(tostring(playerObj:getModData().AlcoholicHasWithdrawalSickness))
    statsWindow["withdrawal_phase"]:setText(tostring(playerObj:getModData().AlcoholicWithdrawalPhase))
    statsWindow["has_drank"]:setText(tostring(playerObj:getModData().AlcoholicHasDrank))

    statsWindow:setPositionPanel(playerWindow:getX() + playerWindow:getWidth(), playerWindow:getY())
    statsWindow:open()
end

local function openAlcoholGUI()
    print("Open Alcohol GUI")
    playerWindow:open()
    visible = true
end

local function closeAlcoholGUI()
    print("Close Alcohol GUI")
    playerWindow:close()
    visible = false
end

local function closeStats()
    statsWindow:close()
end

local function onCreateUI()
    playerWindow = NewUI()
    playerWindow:setTitle("Local players")
    playerWindow:setPercentageWidth(0.15)
    playerWindow:addScrollList("list", players)

    playerWindow["list"]:setOnMouseDownFunction(_, openStats)

    playerWindow:saveLayout()

    statsWindow = NewUI()
    statsWindow:setTitle("Player Alcoholic Stats")
    statsWindow:isSubUIOf(playerWindow)
    statsWindow:setPercentageWidth(0.1)

    statsWindow:addEmpty(_,_,_,10)
    
    statsWindow:addRichText("Alcoholic Stress Level", "Alcoholic Stress Level: ")
    statsWindow:addRichText("stress", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()
    
    statsWindow:addRichText("Alcoholic Tolerance", "Alcoholic Tolerance: ")
    statsWindow:addRichText("tolerance", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Alcoholic Threshold", "Alcoholic Threshold: ")
    statsWindow:addRichText("threshold", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Withdrawal Sickness", "Withdrawal Sickness: ")
    statsWindow:addRichText("withdrawal", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()
    
    statsWindow:addRichText("Alcoholic Tolerance Penalty", "Alcoholic Tolerance Penalty: ")
    statsWindow:addRichText("tolerance_penalty", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Alcoholic Poison Level", "Alcoholic Poison Level: ")
    statsWindow:addRichText("poison", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Time Since Last Drink", "Time Since Last Drink: ")
    statsWindow:addRichText("time_since_last_drink", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Alcoholic Drinks/Day", "Alcoholic Drinks/Day: ")
    statsWindow:addRichText("drinks_per_day", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Alcoholic Drinks Total", "Alcoholic Drinks Total: ")
    statsWindow:addRichText("drinks_total", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Has Withdrawal Sickness", "Has Withdrawal Sickness: ")
    statsWindow:addRichText("has_withdrawal_sickness", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Withdrawal Phase", "Withdrawal Phase: ")
    statsWindow:addRichText("withdrawal_phase", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addRichText("Has Drank Alcohol", "Has Drank Alcohol Last Nour: ")
    statsWindow:addRichText("has_drank", "")
    statsWindow:addEmpty(_,_,_,10)
    statsWindow:nextLine()

    statsWindow:addButton("close_button", "Close", closeStats)
    statsWindow:saveLayout()
    statsWindow:close()
    --playerWindow:close()
end

local function toggleAlcoholicGUI()
    print("Toggled Alcoholic GUI")
    visible = not visible
    if visible
    then
        playerWindow:open()
    else
        playerWindow:close()
    end
end

local function onKeyPressed(key)
    if key == "T"
    then
        toggleAlcoholicGUI()
    end
end


Events.OnKeyPressed.Add(onKeyPressed)

local function onRightClick(player, context, items)
    items = ISInventoryPane.getActualItems(items)
    for _, item in ipairs(items) do
        if item then
            if item:isAlcoholic()
            then
                context:addOption("Show Alcoholic Stats", player, openAlcoholGUI, item)
            end
        end
    end
end

Events.OnCreateUI.Add(onCreateUI)
Events.OnFillInventoryObjectContextMenu.Add(onRightClick)