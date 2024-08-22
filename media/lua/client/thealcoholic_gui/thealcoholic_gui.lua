TheAlcoholic.playerWindow = {}
TheAlcoholic.statsWindow = {}

local players = {}

local function openStats(_, player)
    local playerObj = getSpecificPlayer(player)

    if playerObj == nil then
        return
    end

    TheAlcoholic.statsWindow["stress"]:setText(tostring(playerObj:getModData().AlcoholicStress))
    TheAlcoholic.statsWindow["tolerance"]:setText(tostring(playerObj:getModData().AlcoholicTolerance))
    TheAlcoholic.statsWindow["threshold"]:setText(tostring(playerObj:getModData().AlcoholicThreshold))
    TheAlcoholic.statsWindow["withdrawal"]:setText(tostring(playerObj:getModData().AlcoholicWithdrawalSickness))
    TheAlcoholic.statsWindow["tolerance_penalty"]:setText(tostring(playerObj:getModData().AlcoholicTolerancePenalty))
    TheAlcoholic.statsWindow["poison"]:setText(tostring(playerObj:getModData().AlcoholicPoisonDamageTotal))
    TheAlcoholic.statsWindow["time_since_last_drink"]:setText(tostring(playerObj:getModData().AlcoholicTimeSinceLastDrink))
    TheAlcoholic.statsWindow["drinks_per_day"]:setText(tostring(playerObj:getModData().AlcoholicDrinksPerDay))
    TheAlcoholic.statsWindow["drinks_total"]:setText(tostring(playerObj:getModData().AlcoholicDrinksTotal))
    TheAlcoholic.statsWindow["has_withdrawal_sickness"]:setText(tostring(playerObj:getModData().AlcoholicHasWithdrawalSickness))
    TheAlcoholic.statsWindow["withdrawal_phase"]:setText(tostring(playerObj:getModData().AlcoholicWithdrawalPhase))
    TheAlcoholic.statsWindow["has_drank"]:setText(tostring(playerObj:getModData().AlcoholicHasDrank))

    TheAlcoholic.statsWindow:setPositionPixel(TheAlcoholic.playerWindow:getX() + TheAlcoholic.playerWindow:getWidth(), TheAlcoholic.playerWindow:getY())
    TheAlcoholic.statsWindow:open()
end

local function closeStats()
    TheAlcoholic.statsWindow:close()
end

local function updateInfo()
    if TheAlcoholic.playerWindow:getIsVisible() == false
    then
        for i = 0, getNumActivePlayers()-1 do
            local player = getSpecificPlayer(i)
            players[player:getName()] = i
        end
    end
end

local function toggleAlcoholicGUI()
    TheAlcoholic.playerWindow:toggle()
end

local function onCreateUI()
    for i=0, 3 do
        local player_str = "Player "..(i+1)
        players[player_str] = i
    end
    TheAlcoholic.playerWindow = NewUI()
    TheAlcoholic.playerWindow:setTitle("Local players")
    TheAlcoholic.playerWindow:setWidthPercent(0.15)
    TheAlcoholic.playerWindow:setPositionPercent(0.35, 0.15)
    TheAlcoholic.playerWindow:addScrollList("list", players)

    TheAlcoholic.playerWindow["list"]:setOnMouseDownFunction(_, openStats)

    TheAlcoholic.playerWindow:saveLayout()

    TheAlcoholic.statsWindow = NewUI()
    TheAlcoholic.statsWindow:setTitle("Player Alcoholic Stats")
    TheAlcoholic.statsWindow:isSubUIOf(TheAlcoholic.playerWindow)
    TheAlcoholic.statsWindow:setWidthPercent(0.35)
    
    TheAlcoholic.statsWindow:addRichText("AlcoholicStressLevel", "Alcoholic Stress Level: ")
    TheAlcoholic.statsWindow:addRichText("stress", "")
    TheAlcoholic.statsWindow:nextLine()
    
    TheAlcoholic.statsWindow:addRichText("AlcoholicTolerance", "Alcoholic Tolerance: ")
    TheAlcoholic.statsWindow:addRichText("tolerance", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("AlcoholicThreshold", "Alcoholic Threshold: ")
    TheAlcoholic.statsWindow:addRichText("threshold", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("WithdrawalSickness", "Withdrawal Sickness: ")
    TheAlcoholic.statsWindow:addRichText("withdrawal", "")
    TheAlcoholic.statsWindow:nextLine()
    
    TheAlcoholic.statsWindow:addRichText("AlcoholicTolerancePenalty", "Alcoholic Tolerance Penalty: ")
    TheAlcoholic.statsWindow:addRichText("tolerance_penalty", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("AlcoholicPoisonLevel", "Alcoholic Poison Level: ")
    TheAlcoholic.statsWindow:addRichText("poison", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("TimeSinceLastDrink", "Time Since Last Drink: ")
    TheAlcoholic.statsWindow:addRichText("time_since_last_drink", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("AlcoholicDrinksToday", "Alcoholic Drinks Today: ")
    TheAlcoholic.statsWindow:addRichText("drinks_per_day", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("AlcoholicDrinksTotal", "Alcoholic Drinks Total: ")
    TheAlcoholic.statsWindow:addRichText("drinks_total", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("HasWithdrawalSickness", "Has Withdrawal Sickness: ")
    TheAlcoholic.statsWindow:addRichText("has_withdrawal_sickness", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("WithdrawalPhase", "Withdrawal Phase: ")
    TheAlcoholic.statsWindow:addRichText("withdrawal_phase", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addRichText("HasDrankAlcohol", "Has Drank Alcohol Last Nour: ")
    TheAlcoholic.statsWindow:addRichText("has_drank", "")
    TheAlcoholic.statsWindow:nextLine()

    TheAlcoholic.statsWindow:addButton("close_button", "Close", closeStats)
    TheAlcoholic.statsWindow:addButton("close_all", "Close All", toggleAlcoholicGUI)
    TheAlcoholic.statsWindow:saveLayout()
    TheAlcoholic.statsWindow:close()
    TheAlcoholic.playerWindow:close()
    Events.OnTick.Remove(onCreateUI)
end

function TheAlcoholic.onKeyPressed(key)
    if key == "T"
    then
        toggleAlcoholicGUI()
    end
end


Events.OnKeyPressed.Add(TheAlcoholic.onKeyPressed)

function TheAlcoholic.onRightClick(player, context, items)
    print("TheAlcoholic.onRightClick")
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
Events.OnFillInventoryObjectContextMenu.Add(TheAlcoholic.onRightClick)