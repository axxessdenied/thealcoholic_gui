-- (c) 2024 - axxessdenied [Nick Slusarczyk]

TheAlcoholic.UI = {}
TheAlcoholic.UI.playerWindow = {}
TheAlcoholic.UI.statsWindow = {}
TheAlcoholic.UI.visible = false

TheAlcoholic.UI.playerCache = {}

local function refreshStats()
    TheAlcoholic.UI.statsWindow["has_alcoholic"]:setText(tostring(TheAlcoholic.UI.playerCache:HasTrait("Alcoholic")))
    TheAlcoholic.UI.statsWindow["stress"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicStress))
    TheAlcoholic.UI.statsWindow["tolerance"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicTolerance))
    TheAlcoholic.UI.statsWindow["threshold"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicThreshold))
    TheAlcoholic.UI.statsWindow["withdrawal"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicWithdrawalSickness))
    TheAlcoholic.UI.statsWindow["tolerance_penalty"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicTolerancePenalty))
    TheAlcoholic.UI.statsWindow["poison"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicPoisonDamageTotal))
    TheAlcoholic.UI.statsWindow["time_since_last_drink"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicTimeSinceLastDrink))
    TheAlcoholic.UI.statsWindow["drinks_per_day"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicDrinksPerDay))
    TheAlcoholic.UI.statsWindow["drinks_total"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicDrinksTotal))
    TheAlcoholic.UI.statsWindow["has_withdrawal_sickness"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicHasWithdrawalSickness))
    TheAlcoholic.UI.statsWindow["withdrawal_phase"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicWithdrawalPhase))
    TheAlcoholic.UI.statsWindow["has_drank"]:setText(tostring(TheAlcoholic.UI.playerCache:getModData().AlcoholicHasDrank))
end

local function openStats(_, player)
    local playerObj = getSpecificPlayer(player)

    if playerObj == nil then
        return
    end

    TheAlcoholic.UI.playerCache = playerObj
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
        local player1, player2, player3, player4 = getSpecificPlayer(0), getSpecificPlayer(1), getSpecificPlayer(2), getSpecificPlayer(3)
        local playerCount = getNumActivePlayers()
        local player1_str = playerCount > 0 and player1:getUsername() or getText("UI_alcoholic_text_no_player")
        local player2_str = playerCount > 1 and player2:getUsername() or getText("UI_alcoholic_text_no_player")
        local player3_str = playerCount > 2 and player3:getUsername() or getText("UI_alcoholic_text_no_player")
        local player4_str = playerCount > 3 and player4:getUsername() or getText("UI_alcoholic_text_no_player")

        if playerCount < 2
        then
            TheAlcoholic.UI.playerWindow["list"]:setItems({ [player1_str] = 0 })
        elseif playerCount == 2
        then
            TheAlcoholic.UI.playerWindow["list"]:setItems({ [player1_str] = 0, [player2_str] = 1 })
        elseif playerCount == 3
        then
            TheAlcoholic.UI.playerWindow["list"]:setItems({ [player1_str] = 0, [player2_str] = 1, [player3_str] = 2 })
        elseif playerCount == 4
        then
            TheAlcoholic.UI.playerWindow["list"]:setItems({ [player1_str] = 0, [player2_str] = 1, [player3_str] = 2, [player4_str] = 3 })
        end
    end
end

local function toggleAlcoholicGUI()
    TheAlcoholic.UI.visible = not TheAlcoholic.UI.visible
    updatePlayers()
    TheAlcoholic.UI.playerWindow:toggle()
end

local function refresh_players()
    TheAlcoholic.UI.playerWindow:close()
    updatePlayers()
    TheAlcoholic.UI.playerWindow:open()
end

local function refresh_button_click()
    TheAlcoholic.UI.statsWindow:close()
    refreshStats()
    TheAlcoholic.UI.statsWindow:open()
end

local function onCreateUI()
    local players = {} 
    for i=0, 3 do
        local player_str = getText("UI_alcoholic_text_player").." "..(i+1)
        players[player_str] = i
    end
    TheAlcoholic.UI.playerWindow = NewUI()
    TheAlcoholic.UI.playerWindow:setTitle(getText("UI_alcoholic_pw_title"))
    TheAlcoholic.UI.playerWindow:setWidthPercent(0.07)
    TheAlcoholic.UI.playerWindow:setPositionPercent(0.10, 0.25)
    TheAlcoholic.UI.playerWindow:addScrollList("list", players)
    TheAlcoholic.UI.playerWindow:nextLine()
    TheAlcoholic.UI.playerWindow:addButton("refresh_button", getText("UI_alcoholic_refresh_button"), refresh_players)
    TheAlcoholic.UI.playerWindow:nextLine()
    TheAlcoholic.UI.playerWindow:addButton("close_button", getText("UI_alcoholic_close_button"), toggleAlcoholicGUI)
    TheAlcoholic.UI.playerWindow:setCollapse(true)

    TheAlcoholic.UI.playerWindow["list"]:setOnMouseDownFunction(_, openStats)

    TheAlcoholic.UI.playerWindow:saveLayout()

    TheAlcoholic.UI.statsWindow = NewUI()
    TheAlcoholic.UI.statsWindow:setTitle(getText("UI_alcoholic_sw_title"))
    TheAlcoholic.UI.statsWindow:isSubUIOf(TheAlcoholic.UI.playerWindow)
    TheAlcoholic.UI.statsWindow:setWidthPercent(0.10)
    TheAlcoholic.UI.statsWindow:setCollapse(true)

    TheAlcoholic.UI.statsWindow:setDefaultLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("has_alcoholic_label", getText("UI_alcoholic_has_alcoholic_label"))
    TheAlcoholic.UI.statsWindow["has_alcoholic_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("has_alcoholic", "")
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:nextLine()
    
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("stress_label", getText("UI_alcoholic_stress_label"))
    TheAlcoholic.UI.statsWindow["stress_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("stress", "")
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:nextLine()
    
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("tolerance_label", getText("UI_alcoholic_tolerance_label"))
    TheAlcoholic.UI.statsWindow["tolerance_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("tolerance", "")
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("threshold_label", getText("UI_alcoholic_threshold_label"))
    TheAlcoholic.UI.statsWindow["threshold_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("threshold", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("tp_label", getText("UI_alcoholic_tp_label"))
    TheAlcoholic.UI.statsWindow["tp_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("tolerance_penalty", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("poison_label", getText("UI_alcoholic_poison_label"))
    TheAlcoholic.UI.statsWindow["poison_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("poison", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("tsld_label", getText("UI_alcoholic_tsld_label"))
    TheAlcoholic.UI.statsWindow["tsld_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("time_since_last_drink", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("dpd_label", getText("UI_alcoholic_dpd_label"))
    TheAlcoholic.UI.statsWindow["dpd_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("drinks_per_day", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("dt_label", getText("UI_alcoholic_dt_label"))
    TheAlcoholic.UI.statsWindow["dt_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("drinks_total", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("wp_label", getText("UI_alcoholic_wp_label"))
    TheAlcoholic.UI.statsWindow["wp_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("withdrawal_phase", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("hws_label", getText("UI_alcoholic_hws_label"))
    TheAlcoholic.UI.statsWindow["hws_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("has_withdrawal_sickness", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("withdrawal_label", getText("UI_alcoholic_ws_label"))
    TheAlcoholic.UI.statsWindow["withdrawal_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("withdrawal", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:addRichText("has_drank_label", getText("UI_alcoholic_hda_label"))
    TheAlcoholic.UI.statsWindow["has_drank_label"]:setWidthPercent(0.07)
    TheAlcoholic.UI.statsWindow:addRichText("has_drank", "")
    TheAlcoholic.UI.statsWindow:addEmpty(_,_,_, 10)
    TheAlcoholic.UI.statsWindow:setLineHeightPixel(getTextManager():getFontHeight(UIFont.Small))
    TheAlcoholic.UI.statsWindow:nextLine()

    TheAlcoholic.UI.statsWindow:addButton("refresh_button", getText("UI_alcoholic_refresh_button"), refresh_button_click)
    TheAlcoholic.UI.statsWindow:nextLine()   
    TheAlcoholic.UI.statsWindow:addButton("close_button", getText("UI_alcoholic_close_button"), closeStats)
    TheAlcoholic.UI.statsWindow:addButton("close_all", getText("UI_alcoholic_close_all_button"), toggleAlcoholicGUI)
    TheAlcoholic.UI.statsWindow:saveLayout()
    TheAlcoholic.UI.statsWindow:close()
    TheAlcoholic.UI.playerWindow:close()
end

function TheAlcoholic.UI.onRightClickItem(player, context, items)
    items = ISInventoryPane.getActualItems(items)
    local has_displayed = false
    for _, item in ipairs(items) do
        if item then
            if item:isAlcoholic() == true and has_displayed == false
            then
                local menu_str = TheAlcoholic.UI.visible and getText("UI_alcoholic_hide_button") or getText("UI_alcoholic_show_button")
                context:addOption(menu_str, player, toggleAlcoholicGUI, item)
                has_displayed = true
            end
        end
    end
end

function TheAlcoholic.UI.onRightClick(player, context, worldObjects, test)
    local menu_str = TheAlcoholic.UI.visible and getText("UI_alcoholic_hide_button") or getText("UI_alcoholic_show_button")
    context:addOption(menu_str, player, toggleAlcoholicGUI, worldObjects)
end

Events.OnCreateUI.Add(onCreateUI)
Events.OnFillInventoryObjectContextMenu.Add(TheAlcoholic.UI.onRightClickItem)
Events.OnFillWorldObjectContextMenu.Add(TheAlcoholic.UI.onRightClick)