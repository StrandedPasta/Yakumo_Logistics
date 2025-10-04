--Variables
local drive = {}
local modem = nil
local reset = false
local erroramount = 0
local errorfile = ""

settings.define("Item.setting", {
        default = nil,
        })

settings.define("Liquid.setting", {
    default = nil,
    })

settings.define("Error.setting", {
    default = 0,
    })

--Functions
function setFiles()
    
    if not fs.exists("drive.txt") then
        fs.copy("template.txt","drive.txt")
    end


    settings.load()

    modem = peripheral.find("modem")

    if not fs.exists("blacklist.txt") then
        fs.copy("template.txt","blacklist.txt")
        local file = fs.open("blacklist.txt", "w")
        file.writeLine("drive")
        file.writeLine("minecraft:chest")
        file.writeLine("minecraft:barrel")
        file.writeLine("create:fluid_tank")
        file.close()
    end

    if not fs.exists("submodes.txt") then
        fs.copy("template.txt","submodes.txt")
        local file = fs.open("submodes.txt", "w")
        file.writeLine(".Mix")
        file.writeLine(".FluidMix")
        file.writeLine(".Craft")
        file.writeLine(".Transfer")
        file.close()
    end

    if not fs.exists("peripherals.txt") then
        fs.copy("template.txt","peripherals.txt")
    end

    if not fs.exists("errorlogs") then
        fs.makeDir("errorlogs")
    else
        local list = fs.list("/errorlogs/")
        local log = "/errorlogs/" .. settings.get("Error.setting") .. "_" .. textutils.formatTime(os.time("local"),true) .. "_errorlog.txt"
        if #list > 2 then
            local string = "/errorlogs/" .. list[1]
            if string.sub(list[2],1,1) ~= string.sub(log,12,12) then
                for i = 1, #list do
                    local string2 = "/errorlogs/" .. list[i]
                    fs.delete(string2)
                end
            else
                fs.delete(string)
            end
        end
        local count = settings.get("Error.setting")
        settings.set("Error.setting",count + 1)
        settings.save()
        fs.copy("template.txt",log)
        errorfile = log
    end
    setDrive()
end

function setDrive()
    local slot = 1
    drive = {}
    local driver = fs.open("drive.txt", "r") 
    while driver ~= nil or driver ~= "" do
        local line = driver.readLine()
        if not line then
            driver.close()
            break
        end
        drive[slot] = line
        slot = slot + 1
    end
end

function systemHudSetup()
    local selected = 1

    while true do
        term.setBackgroundColor(colors.black)
        term.clear()

        drawScreen(36,14,50,18)
        term.setCursorPos(39,16)
        term.setTextColor(colors.red)
        print("Errors:", erroramount)

        if selected == 1 then
            drawSelection(2,2,16,6,true)
            term.setCursorPos(6,4)
            print("Factory")

            drawSelection(2,8,16,12,false)
            term.setCursorPos(4,10)
            print("Peripherals")

            drawSelection(2,14,16,18,false)
            term.setCursorPos(6,16)
            print("Backup")

            drawSelection(19,14,33,18,false)
            term.setCursorPos(22,16)
            print("Error Log")

        elseif selected == 2 then
            drawSelection(2,2,16,6,false)
            term.setCursorPos(6,4)
            print("Factory")

            drawSelection(2,8,16,12,true)
            term.setCursorPos(4,10)
            print("Peripherals")

            drawSelection(2,14,16,18,false)
            term.setCursorPos(6,16)
            print("Backup")

            drawSelection(19,14,33,18,false)
            term.setCursorPos(22,16)
            print("Error Log")

        elseif selected == 3 then
            drawSelection(2,2,16,6,false)
            term.setCursorPos(6,4)
            print("Factory")

            drawSelection(2,8,16,12,false)
            term.setCursorPos(4,10)
            print("Peripherals")

            drawSelection(2,14,16,18,true)
            term.setCursorPos(6,16)
            print("Backup")

            drawSelection(19,14,33,18,false)
            term.setCursorPos(22,16)
            print("Error Log")

        elseif selected == 4 then
            drawSelection(2,2,16,6,false)
            term.setCursorPos(6,4)
            print("Factory")

            drawSelection(2,8,16,12,false)
            term.setCursorPos(4,10)
            print("Peripherals")

            drawSelection(2,14,16,18,false)
            term.setCursorPos(6,16)
            print("Backup")

            drawSelection(19,14,33,18,true)
            term.setCursorPos(22,16)
            print("Error Log")
        end

        local event, key, is_held = os.pullEvent("key")
        if keys.getName(key) == "down" and selected < 4 then
            selected = selected + 1

        elseif keys.getName(key) == "up" and selected > 1 then
            selected = selected - 1

        elseif keys.getName(key) == "left" and selected == 4 then
            selected = selected - 1

        elseif keys.getName(key) == "right" and selected == 3 then
            selected = selected + 1

        elseif keys.getName(key) == "enter" then
            if selected == 1 then
                chainHub()
            elseif selected == 2 then
                peripheralHud()
            elseif selected == 3 then
                backupHud()
            elseif selected == 4 then
                errorList()
            end
        end
        sleep(0.1)
    end
end

function chainHub()
    local selected = 1
    local count = 0
    if drive[1] ~= "" then
        for i = 1, #drive do
            local wrap = peripheral.wrap(drive[i])
            local disk = wrap.getMountPath()
            count = count + fs.getFreeSpace(disk)
        end

        while true do
            drawScreen(2,14,50,18)
            term.setCursorPos(4,16)
            perps = peripheral.getNames()
            print("Space Left:", count)
            if selected == 1 then
                drawSelection(2,2,15,6,true)
                term.setCursorPos(4,4)
                print("Add Chain")

                drawSelection(19,2,33,6,false)
                term.setCursorPos(21,4)
                print("List Chains")

                drawSelection(37,2,50,6,false)
                term.setCursorPos(39,4)
                print("Del Chain")

                drawSelection(2,8,15,12,false)
                term.setCursorPos(5,10)
                print("Add Sub")

                drawSelection(19,8,33,12,false)
                term.setCursorPos(22,10)
                print("Del Sub")

            elseif selected == 2 then
                drawSelection(2,2,15,6,false)
                term.setCursorPos(4,4)
                print("Add Chain")

                drawSelection(19,2,33,6,true)
                term.setCursorPos(21,4)
                print("List Chains")

                drawSelection(37,2,50,6,false)
                term.setCursorPos(39,4)
                print("Del Chain")

                drawSelection(2,8,15,12,false)
                term.setCursorPos(5,10)
                print("Add Sub")

                drawSelection(19,8,33,12,false)
                term.setCursorPos(22,10)
                print("Del Sub")

            elseif selected == 3 then
                drawSelection(2,2,15,6,false)
                term.setCursorPos(4,4)
                print("Add Chain")

                drawSelection(19,2,33,6,false)
                term.setCursorPos(21,4)
                print("List Chains")

                drawSelection(37,2,50,6,true)
                term.setCursorPos(39,4)
                print("Del Chain")

                drawSelection(2,8,15,12,false)
                term.setCursorPos(5,10)
                print("Add Sub")

                drawSelection(19,8,33,12,false)
                term.setCursorPos(22,10)
                print("Del Sub")

            elseif selected == 4 then
                drawSelection(2,2,15,6,false)
                term.setCursorPos(4,4)
                print("Add Chain")

                drawSelection(19,2,33,6,false)
                term.setCursorPos(21,4)
                print("List Chains")

                drawSelection(37,2,50,6,false)
                term.setCursorPos(39,4)
                print("Del Chain")

                drawSelection(2,8,15,12,true)
                term.setCursorPos(5,10)
                print("Add Sub")

                drawSelection(19,8,33,12,false)
                term.setCursorPos(22,10)
                print("Del Sub")

                elseif selected == 5 then
                drawSelection(2,2,15,6,false)
                term.setCursorPos(4,4)
                print("Add Chain")

                drawSelection(19,2,33,6,false)
                term.setCursorPos(21,4)
                print("List Chains")

                drawSelection(37,2,50,6,false)
                term.setCursorPos(39,4)
                print("Del Chain")

                drawSelection(2,8,15,12,false)
                term.setCursorPos(5,10)
                print("Add Sub")

                drawSelection(19,8,33,12,true)
                term.setCursorPos(22,10)
                print("Del Sub")
                
            end
            local event, key, is_held = os.pullEvent("key")

            if keys.getName(key) == "right" and selected < 5 then
                selected = selected + 1
            elseif keys.getName(key) == "left" and selected > 1 then
                selected = selected - 1
            elseif keys.getName(key) == "down" and selected < 3 then
                selected = selected + 3
            elseif keys.getName(key) == "up" and selected > 3 then
                selected = selected - 3
            elseif keys.getName(key) == "backspace" then
                break
            elseif keys.getName(key) == "enter" then
                if selected == 1 then
                    addRecipe()
                elseif selected == 2 then
                    readRecipe()
                elseif selected == 3 then
                    removeRecipe()
                elseif selected == 4 then
                    addSubMode()
                elseif selected == 5 then
                    deleteSubMode()
                end
            end
            sleep(0.1)
        end
    else
        print("Error: No Drive chosen")
    end
end

function addRecipe()
    local modes = {{".Mix", addMix}, {".FluidMix", addFluidMix},{".Craft", addCraft}, {".Transfer", addTransfer}}
    local allmodes = {}
    if drive ~= nil then
        local slot = 1
        local submodefile = fs.open("submodes.txt", "r")
        while true do
        local line = submodefile.readLine()
            if not line or line == "nil" then
                submodefile.close()
                break
            end
            allmodes[slot] = line
            slot = slot + 1
        end
        drawFullScreen()
        local selected = setListPages(allmodes,"Choose Mode:")
        local point = ""
        if selected ~= -1 then
            for j = 1, string.len(allmodes[selected]) do
                if string.sub(allmodes[selected],j,j) == "." then
                        point = j
                    break
                end
            end
            local frame = string.sub(allmodes[selected],point)
            for i = 1, #modes do
                if frame == modes[i][1] then
                    modes[i][2](string.sub(allmodes[selected],1,point-1))
                    break
                end
            end
            reset = true
        end
    else
        term.setCursorPos(3,14)
        print("Error: No Drive in Network!")
        sleep(0.5)
    end
end

function removeRecipe()
    local page = 1
    local sure = true
    local files = {}

    if drive ~= nil then
        drawFullScreen()
        for i = 1, #drive do
            local path = peripheral.wrap(drive[i])
            local mount = path.getMountPath()
            local list = fs.list(mount)
            local templist = {}
            for j = 1, #list do
                templist[j] = mount .. "/" .. list[j]
            end
            files = tableCombine(files,templist)
        end
        while true do
            local selected = setListPages(files,"Select Removal:",true)
                while selected ~= -1 do
                    drawScreen(2,2,50,8)
                    term.setCursorPos(4,4)
                    print("Are you sure you want to delete")
                    term.setCursorPos(4,5)
                    print(files[selected], "?")
                    term.setCursorPos(4,6)
                    if sure == true then
                        print("> Yes     No")
                    else
                        print("  Yes   > No")
                    end

                    local event, key, is_held = os.pullEvent("key")
                    if keys.getName(key) == "left" and sure == false then
                        sure = true
                    elseif keys.getName(key) == "right" and sure == true then
                        sure = false
                    elseif keys.getName(key) == "enter" then
                        if sure == true then
                            reset = true
                            fs.delete(files[selected])
                            break
                        else
                            break
                        end
                    end
                end
                break
            end
    else
        term.setCursorPos(3,14)
        print("Error: No Drive in Network!")
        sleep(0.5)
    end
end

function readRecipe()
    local counter = 1
    local files = {}
    local doc = {}
    if drive[1] ~= nil or drive[1] ~= "" then
        for i = 1, #drive do
            local path = peripheral.wrap(drive[i])
            local mount = path.getMountPath()
            local list = fs.list(mount)
            local templist = {}
            for j = 1, #list do
                templist[j] = mount .. "/" .. list[j]
            end
            files = tableCombine(files,templist)
        end
            drawFullScreen()
            local selected = setListPages(files,"Choose Recipe:")
            local flies = fs.open(files[selected],"r")
            while true do
                local line = flies.readLine()
                if not line then
                    flies.close()
                    break
                end
                doc[counter] = line
                counter = counter + 1
            end
            readTable(doc)
    else
        term.setCursorPos(3,14)
        print("Error: No Drive in Network!")
        sleep(0.5)
    end
end

function addSubMode()
    local framework= {".Mix", ".LiquidMix",".Craft",".Transfer"}
    local selected = 1
    local save = true
    local line1 = ""
    local line2 = ""
    local loop = 1
    local total = {}
    
    drawFullScreen()
    term.setCursorPos(4,4)
    print("Name SubMode:")
    term.setCursorPos(4,5)
    line1 = read()
    drawFullScreen()
    term.setCursorPos(4,4)
    print("Choose Framework:")
    while true do
        for i = 1, #framework do
            term.setCursorPos(4,5+i)
            if i == selected then
                print(framework[i], "<")
            else
                print(framework[i], " ")
            end
        end
        local event, key, is_held = os.pullEvent("key")
        if keys.getName(key) == "down" and selected < #framework then
            selected = selected + 1
        elseif keys.getName(key) == "up" and selected > 0 then
            selected = selected - 1
        elseif keys.getName(key) == "enter" then
            line2 = framework[selected]
            break
        end
    end
    local line = line1 .. line2

    drawScreen(2,2,50,7)
    while true do
            term.setCursorPos(4,4)
            print("Save as", line, "?")
            term.setCursorPos(4,5)
            if save == true then
                print("> Save")
                term.setCursorPos(12,5)
                print("  Cancel")
            else
                print("  Save")
                term.setCursorPos(12,5)
                print("> Cancel")
            end
        local event, key, is_held = os.pullEvent("key")
            if keys.getName(key) == "left" and save== false then
                save = true
            elseif keys.getName(key) == "right" and save == true then
                save = false
            elseif keys.getName(key) == "backspace" then
                save = false
                break
            elseif keys.getName(key) == "enter" then
                break
            end
    end
    if save == true then
        local submodesr = fs.open("submodes.txt","r")
        while true do
            local subline = submodesr.readLine()
            if not subline then
                submodesr.close()
                break
            end
            if subline ~= "" then
                total[loop] = subline
                loop = loop + 1
            end
        end
        local submodesw = fs.open("submodes.txt","w")
        for i = 1, #total + 1 do
            if i < #total + 1 then
                submodesw.writeLine(total[i])
            else 
                submodesw.writeLine(line)
            end
        end
        submodesw.close()
    end
end

function deleteSubMode()

    local peripherals = {}
    local slot = 1
        
    drawFullScreen()
    local peripheralfile = fs.open("submodes.txt", "r") 
    while true do
        local line = peripheralfile.readLine()
        if not line or line == "" then
            peripheralfile.close()
            break
        end
        peripherals[slot] = line
        slot = slot + 1
    end
    while true do
        selected = setListPages(peripherals,"Select Submode:", true)
            if selected ~= 1 and selected ~= 2 and selected ~= 3 and selected ~= 4 and selected ~= -1 then
            peripherals[selected] = "nil"
            local perip = fs.open("submodes.txt","w")
                for i = 1, #peripherals + 1 do
                    if i < #peripherals + 1 and peripherals[i] ~= "nil" then
                        perip.writeLine(peripherals[i])
                    elseif i == #peripherals + 1 then
                        perip.writeLine("")
                    end
                end
                perip.close()
                break
            elseif selected == -1 then
                break
            else
                term.setCursorPos(20,4)
                print("You can't delete a Framework!")
                sleep(3)
                drawFullScreen()
            end
    end
    reset = true
end


function addCraft(sub)
    local name
    local pattern1
    local pattern2
    local pattern3
    local variables = {}
    local output
    local outputAmount
    local selected = true
    local scroll = 0
    local per = 0
    local all = peripheral.getNames()
    local Input
    local Turtle
    local Output

        if drive[1] ~= nil or drive[1] ~= "" then
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Name Recipe:")
        term.setCursorPos(4,5)
        name = read()
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Set up Pattern (X = Blank):")
        term.setCursorPos(4,5)
        pattern1 = read()
        term.setCursorPos(4,6)
        pattern2 = read()
        term.setCursorPos(4,7)
        pattern3 = read()
        sleep(0.5)
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Enter Variables (Ex: A = minecraft:dirt)")
        term.setCursorPos(4,5)
        print("Leave blank when done:")
        for i = 1, 9 do
            term.setCursorPos(4,5+i)
            variables[i] = read()
            term.setCursorPos(4,5+i)
            print(variables[i])
            if variables[i] == "" then
                break
            end
        end
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Enter Batch (Default = 1):")
        term.setCursorPos(4,5)
        per = read()
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Enter Output (Ex: minecraft:dirt):")
        term.setCursorPos(4,5)
        output = read()
        term.setCursorPos(4,6)
        print("Enter Desire:")
        term.setCursorPos(4,7)
        outputAmount = read()
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Select Input:")
        Input = selectIOList(all)
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Select Turtle:")
        Turtle = selectIOList(all)
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Select Output:")
        Output = selectIOList(all)
        while true do
            --Results
            if scroll == 0 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,9)
                print("Name:")
                term.setCursorPos(4,10)
                print(name)
                term.setCursorPos(4,12)
                print("Pattern:")
                term.setCursorPos(4,13)
                print(pattern1)
                term.setCursorPos(4,14)
                print(pattern2)
                term.setCursorPos(4,15)
                print(pattern3)
            elseif scroll == 1 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,8)
                print("Variables:")
                for i = 1, #variables, 1 do
                    term.setCursorPos(4,8+i)
                    if variables[i] ~= "nil" then
                        print(variables[i])
                    end
                end
            elseif scroll == 2 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,9)
                print("Output:")
                term.setCursorPos(4,10)
                print(output)
                term.setCursorPos(4,11)
                print("Desired:")
                term.setCursorPos(4,12)
                print(outputAmount)
                term.setCursorPos(4,13)
                print("Batches of:")
                term.setCursorPos(4,14)
                print(per)
            elseif scroll == 3 then
                drawScreen(2,7,50,18)
                term.setCursorPos(4,9)
                print("Input:")
                term.setCursorPos(4,10)
                print(Input)
                term.setCursorPos(4,11)
                print("Turtle:")
                term.setCursorPos(4,12)
                print(Turtle)
                term.setCursorPos(4,13)
                print("Output:")
                term.setCursorPos(4,14)
                print(Output)
            end

            --Savebox
            paintutils.drawFilledBox(0,0,50,7,colors.black)
            paintutils.drawFilledBox(2,2,50,7, colors.white)
            paintutils.drawBox(2,2,50,7, colors.lightGray)
            term.setBackgroundColor(colors.white)
            term.setTextColor(colors.black)
            term.setCursorPos(4,4)
            print("Save Recipe?")
            term.setCursorPos(4,5)
            if selected == true then
                print("> Save")
                term.setCursorPos(12,5)
                print("  Cancel")
            else
                print("  Save")
                term.setCursorPos(12,5)
                print("> Cancel")
            end

            --Keypresses
            local event, key, is_held = os.pullEvent("key")
            if keys.getName(key) == "down" and scroll < 3 then
                scroll = scroll + 1
            elseif keys.getName(key) == "up" and scroll > 0 then
                scroll = scroll - 1
            elseif keys.getName(key) == "left" and selected == false then
                selected = true
            elseif keys.getName(key) == "right" and selected == true then
                selected = false
            elseif keys.getName(key) == "backspace" then
                break
            elseif keys.getName(key) == "enter" then
                if selected == true then
                    local text = name .. ".txt"
                    fs.copy("template.txt", text)
                    local file = fs.open(text, "w")
                    if sub ~= nil then
                        local path = sub .. ".Craft"
                        file.writeLine(path)
                    else
                        file.writeLine(".Craft")
                    end
                    local patternFull = pattern1 .. "X" .. pattern2 .. "X" .. pattern3
                    file.writeLine(patternFull)
                    for i = 1, #variables, 1 do
                        if variables[i] ~= "" then
                            file.writeLine(variables[i])
                        end
                    end
                    file.writeLine("X = nil")
                    file.writeLine("")
                    file.writeLine(Input)
                    file.writeLine(Turtle)
                    file.writeLine(Output)
                    file.writeLine("")
                    file.writeLine(per)
                    file.writeLine(output)
                    file.writeLine(outputAmount)
                    file.writeLine("")
                    file.writeLine("Pattern:")
                    file.writeLine(pattern1)
                    file.writeLine(pattern2)
                    file.writeLine(pattern3)
                    file.close()
                    for i = 1, #drive do
                    local path = peripheral.wrap(drive[i])
                    local mount = path.getMountPath()
                    local disk = mount .. "/" .. text
                        if fs.move(text,disk) then
                            break
                        end
                    end
                    break
                else
                    break
                end
            end
            sleep(0.1)
        end
    end
end

function addMix(sub)
    local name
    local item
    local itemAmount
    local In
    local Amt
    local recipe = {}
    local all = peripheral.getNames()
    local Input
    local InMachine
    local OutMachine
    local Output
    local slot = 1
    local scroll = 0
    local save = true

    if drive[1] ~= nil or drive[1] ~= "" then
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Name Recipe:")
        term.setCursorPos(4,5)
        name = read()
        while true do
            drawFullScreen()
            term.setCursorPos(4,4)
            print("Set Ingredient (Ex: minecraft:dirt):")
            term.setCursorPos(4,5)
            print("(Leave blank when done)")
            term.setCursorPos(4,6)
            In = read()
            if In == "" then
                break
            end
            term.setCursorPos(4,7)
            print("Set Amount:")
            term.setCursorPos(4,8)
            Amt = read()
            local Ingredient = In .. "^" .. Amt
            recipe[slot] = Ingredient
            slot = slot + 1
        end
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Enter Output (Ex: minecraft:dirt):")
        term.setCursorPos(4,5)
        item = read()
        term.setCursorPos(4,5)
        print(item)
        term.setCursorPos(4,6)
        print("Enter Desired:")
        term.setCursorPos(4,7)
        itemAmount = read()
        Input = selectIOList(all,"Select Input:")
        InMachine = selectIOList(all,"Select Machine (Input):")
        OutMachine = selectIOList(all,"Select Machine (Output):")
        Output = selectIOList(all,"Select Output:")
        while true do
            --Results
            if scroll == 0 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,9)
                print("Name:")
                term.setCursorPos(4,10)
                print(name)
                term.setCursorPos(4,12)
                print("Output:")
                term.setCursorPos(4,13)
                print(item)
                term.setCursorPos(4,14)
                print("Desired:")
                term.setCursorPos(4,15)
                print(itemAmount)

            elseif scroll == 1 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,8)
                print("Variables:")
                for i = 1, #recipe do
                    term.setCursorPos(4,8+i)
                    if recipe[i] ~= "nil" then
                        print(recipe[i])
                    end
                end
            elseif scroll == 2 then
                drawScreen(2,7,50,18)
                term.setCursorPos(4,9)
                print("Selected Input:")
                term.setCursorPos(4,10)
                print(Input)
                term.setCursorPos(4,11)
                print("Selected Machine (I):")
                term.setCursorPos(4,12)
                print(InMachine)
                term.setCursorPos(4,13)
                print("Selected Machine (O):")
                term.setCursorPos(4,14)
                print(OutMachine)
                term.setCursorPos(4,15)
                print("Selected Output:")
                term.setCursorPos(4,16)
                print(Output)
            end

            --Savebox
            paintutils.drawFilledBox(0,0,50,7,colors.black)
            paintutils.drawFilledBox(2,2,50,7, colors.white)
            paintutils.drawBox(2,2,50,7, colors.lightGray)
            term.setBackgroundColor(colors.white)
            term.setTextColor(colors.black)
            term.setCursorPos(4,4)
            print("Save Chain?")
            term.setCursorPos(4,5)
            if save == true then
                print("> Save")
                term.setCursorPos(12,5)
                print("  Cancel")
            else
                print("  Save")
                term.setCursorPos(12,5)
                print("> Cancel")
            end

            --Keypresses
            local event, key, is_held = os.pullEvent("key")
            if keys.getName(key) == "down" and scroll < 2 then
                scroll = scroll + 1
            elseif keys.getName(key) == "up" and scroll > 0 then
                scroll = scroll - 1
            elseif keys.getName(key) == "left" and save == false then
                save = true
            elseif keys.getName(key) == "right" and save== true then
                save = false
            elseif keys.getName(key) == "backspace" then
                break
            elseif keys.getName(key) == "enter" then
                if save == true then
                    local text = name .. ".txt"
                    fs.copy("template.txt", text)
                    local file = fs.open(text, "w")
                    if sub ~= nil then
                        local path = sub .. ".Mix"
                        file.writeLine(path)
                    else
                        file.writeLine(".Mix")
                    end
                    for i = 1, #recipe, 1 do
                        if recipe[i] ~= "nil" then
                            file.writeLine(recipe[i])
                        end
                    end
                    file.writeLine("")
                    file.writeLine(Input)
                    file.writeLine(InMachine)
                    file.writeLine(OutMachine)
                    file.writeLine(Output)
                    file.writeLine("")
                    file.writeLine(item)
                    file.writeLine(itemAmount)
                    file.close()
                    for i = 1, #drive do
                    local path = peripheral.wrap(drive[i])
                    local mount = path.getMountPath()
                    local disk = mount .. "/" .. text
                        if fs.move(text,disk) then
                            break
                        end
                    end
                    break
                else
                    break
                end
            end
        end
    else
        term.setCursorPos(3,14)
        print("Error: No Drive in Network!")
        sleep(0.5)
    end
    return true
end

function addTransfer(sub)

    local all = peripheral.getNames()
    local name
    local item
    local itemAmount
    local Input
    local ISlot
    local Output
    local OSlot
    local scroll = 0
    local save = true

    if drive[1] ~= nil or drive[1] ~= "" then
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Name Recipe:")
        term.setCursorPos(4,5)
        name = read()
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Enter Object (Ex: A = minecraft:dirt):")
        term.setCursorPos(4,5)
        item = read()
        term.setCursorPos(4,6)
        print("Enter Desired:")
        term.setCursorPos(4,7)
        itemAmount = read()
        drawFullScreen()
        term.setCursorPos(4,4)
        Input = selectIOList(all, "Select Input:")
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Select Slot (Unused):")
        ISlot = read()
        drawFullScreen()
        term.setCursorPos(4,4)
        Output = selectIOList(all, "Select Output:")
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Select Slot (Optional):")
        OSlot = read()

        while true do
            --Results
            if scroll == 0 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,9)
                print("Name:")
                term.setCursorPos(4,10)
                print(name)
                term.setCursorPos(4,12)
                print("Object:")
                term.setCursorPos(4,13)
                print(item)
                term.setCursorPos(4,14)
                print("Desired:")
                term.setCursorPos(4,15)
                print(itemAmount)

            elseif scroll == 1 then
                drawScreen(2,7,50,18)
                term.setCursorPos(4,9)
                print("Selected Input:")
                term.setCursorPos(4,10)
                print(Input)
                term.setCursorPos(4,11)
                print(ISlot)
                term.setCursorPos(4,13)
                print("Selected Output:")
                term.setCursorPos(4,14)
                print(Output)
                term.setCursorPos(4,15)
                print(OSlot)
            end

            --Savebox
            paintutils.drawFilledBox(0,0,50,7,colors.black)
            paintutils.drawFilledBox(2,2,50,7, colors.white)
            paintutils.drawBox(2,2,50,7, colors.lightGray)
            term.setBackgroundColor(colors.white)
            term.setTextColor(colors.black)
            term.setCursorPos(4,4)
            print("Save Chain?")
            term.setCursorPos(4,5)
            if save == true then
                print("> Save")
                term.setCursorPos(12,5)
                print("  Cancel")
            else
                print("  Save")
                term.setCursorPos(12,5)
                print("> Cancel")
            end

            --Keypresses
            local event, key, is_held = os.pullEvent("key")
            if keys.getName(key) == "down" and scroll < 1 then
                scroll = scroll + 1
            elseif keys.getName(key) == "up" and scroll > 0 then
                scroll = scroll - 1
            elseif keys.getName(key) == "left" and save == false then
                save = true
            elseif keys.getName(key) == "right" and save== true then
                save = false
            elseif keys.getName(key) == "backspace" then
                break
            elseif keys.getName(key) == "enter" then
                if save == true then
                    local text = name .. ".txt"
                    fs.copy("template.txt", text)
                    local file = fs.open(text, "w")
                    if sub ~= nil then
                        local path = sub .. ".Transfer"
                        file.writeLine(path)
                    else
                        file.writeLine(".Transfer")
                    end
                    file.writeLine(item)
                    file.writeLine(itemAmount)
                    file.writeLine("")
                    file.writeLine(Input)
                    file.writeLine(ISlot)
                    file.writeLine(Output)
                    file.writeLine(OSlot)
                    file.close()
                    for i = 1, #drive do
                    local path = peripheral.wrap(drive[i])
                    local mount = path.getMountPath()
                    local disk = mount .. "/" .. text
                        if fs.move(text,disk) then
                            break
                        end
                    end
                    break
                else
                    break
                end
            end
        end
    else
        term.setCursorPos(3,14)
        print("Error: No Drive in Network!")
        sleep(0.5)
    end
end

function addFluidMix(sub)
    local name
    local item
    local itemAmount
    local Item
    local IAmt
    local Fluid
    local LAmt
    local recipe = {}
    local recipe2 = {}
    local all = peripheral.getNames()
    local InputI
    local InputF
    local InMachine
    local OutMachine
    local Output
    local slot = 1
    local scroll = 0
    local save = true

    if drive[1] ~= nil or drive[1] ~= "" then
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Name Recipe:")
        term.setCursorPos(4,5)
        name = read()
        while true do
            drawFullScreen()
            term.setCursorPos(4,4)
            print("Set Items (Ex: minecraft:dirt):")
            term.setCursorPos(4,5)
            print("(Leave blank when done)")
            term.setCursorPos(4,6)
            Item = read()
            if Item == "" then
                break
            end
            term.setCursorPos(4,7)
            print("Set Amount:")
            term.setCursorPos(4,8)
            IAmt = read()
            local Ingredient = Item .. "^" .. IAmt
            recipe[slot] = Ingredient
            slot = slot + 1
        end
        slot = 1
        while true do
            drawFullScreen()
            term.setCursorPos(4,4)
            print("Set Fluids (Ex: minecraft:lava):")
            term.setCursorPos(4,5)
            print("(Leave blank when done)")
            term.setCursorPos(4,6)
            Fluid = read()
            if Fluid == "" then
                break
            end
            term.setCursorPos(4,7)
            print("Set Amount:")
            term.setCursorPos(4,8)
            LAmt = read()
            local Ingredient = Fluid .. "^" .. LAmt
            recipe2[slot] = Ingredient
            slot = slot + 1
        end
        drawFullScreen()
        term.setCursorPos(4,4)
        print("Enter Output (Ex: minecraft:dirt):")
        term.setCursorPos(4,5)
        item = read()
        term.setCursorPos(4,5)
        print(item)
        term.setCursorPos(4,6)
        print("Enter Desired:")
        term.setCursorPos(4,7)
        itemAmount = read()
        drawFullScreen()
        term.setCursorPos(4,4)
        InputI = selectIOList(all,"Select Item Input:")
        drawFullScreen()
        term.setCursorPos(4,4)
        InputF = selectIOList(all,"Select Fluid Input:")
        drawFullScreen()
        term.setCursorPos(4,4)
        InMachine = selectIOList(all,"Select Machine (Input):")
        drawFullScreen()
        term.setCursorPos(4,4)
        OutMachine = selectIOList(all,"Select Machine (Output):")
        drawFullScreen()
        term.setCursorPos(4,4)
        Output = selectIOList(all,"Select Output:")

        while true do
            --Results
            if scroll == 0 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,9)
                print("Name:")
                term.setCursorPos(4,10)
                print(name)
                term.setCursorPos(4,12)
                print("Output:")
                term.setCursorPos(4,13)
                print(item)
                term.setCursorPos(4,14)
                print("Desired:")
                term.setCursorPos(4,15)
                print(itemAmount)

            elseif scroll == 1 then
                drawScreen(2,7,50,28)
                term.setCursorPos(4,8)
                print("Variables:")
                for i = 1, #recipe do
                    term.setCursorPos(4,8+i)
                    if recipe[i] ~= "nil" then
                        print(recipe[i])
                    end
                end
                for j = 1, #recipe2 do
                    term.setCursorPos(4,8+#recipe+j)
                    if recipe2[j] ~= "nil" then
                        print(recipe2[j])
                    end
                end
            elseif scroll == 2 then
                drawScreen(2,7,50,18)
                term.setCursorPos(4,8)
                print("Selected Item Input:")
                term.setCursorPos(4,9)
                print(InputI)
                term.setCursorPos(4,10)
                print("Selected Fluid Input:")
                term.setCursorPos(4,11)
                print(InputF)
                term.setCursorPos(4,12)
                print("Selected Machine (I):")
                term.setCursorPos(4,13)
                print(InMachine)
                term.setCursorPos(4,14)
                print("Selected Machine (O):")
                term.setCursorPos(4,15)
                print(OutMachine)
                term.setCursorPos(4,16)
                print("Selected Output:")
                term.setCursorPos(4,17)
                print(Output)
            end

            --Savebox
            paintutils.drawFilledBox(0,0,50,7,colors.black)
            paintutils.drawFilledBox(2,2,50,7, colors.white)
            paintutils.drawBox(2,2,50,7, colors.lightGray)
            term.setBackgroundColor(colors.white)
            term.setTextColor(colors.black)
            term.setCursorPos(4,4)
            print("Save Chain?")
            term.setCursorPos(4,5)
            if save == true then
                print("> Save")
                term.setCursorPos(12,5)
                print("  Cancel")
            else
                print("  Save")
                term.setCursorPos(12,5)
                print("> Cancel")
            end

            --Keypresses
            local event, key, is_held = os.pullEvent("key")
            if keys.getName(key) == "down" and scroll < 2 then
                scroll = scroll + 1
            elseif keys.getName(key) == "up" and scroll > 0 then
                scroll = scroll - 1
            elseif keys.getName(key) == "left" and save == false then
                save = true
            elseif keys.getName(key) == "right" and save== true then
                save = false
            elseif keys.getName(key) == "backspace" then
                break
            elseif keys.getName(key) == "enter" then
                if save == true then
                    local text = name .. ".txt"
                    fs.copy("template.txt", text)
                    local file = fs.open(text, "w")
                    if sub ~= nil then
                        local path = sub .. ".FluidMix"
                        file.writeLine(path)
                    else
                        file.writeLine(".FluidMix")
                    end
                    for i = 1, #recipe do
                        if recipe[i] ~= "nil" then
                            file.writeLine(recipe[i])
                        end
                    end
                    file.writeLine("")
                    for i = 1, #recipe2 do
                        if recipe2[i] ~= "nil" then
                            file.writeLine(recipe2[i])
                        end
                    end
                    file.writeLine("")
                    file.writeLine(InputI)
                    file.writeLine(InputF)
                    file.writeLine(InMachine)
                    file.writeLine(OutMachine)
                    file.writeLine(Output)
                    file.writeLine("")
                    file.writeLine(item)
                    file.writeLine(itemAmount)
                    file.close()
                    for i = 1, #drive do
                    local path = peripheral.wrap(drive[i])
                    local mount = path.getMountPath()
                    local disk = mount .. "/" .. text
                        if fs.move(text,disk) then
                            break
                        end
                    end
                    break
                else
                    break
                end
            end
        end
    else
        term.setCursorPos(3,14)
        print("Error: No Drive in Network!")
        sleep(0.5)
    end
end

function peripheralHud()
    local selected = 1
    local perps = 0

    while true do
        drawScreen(2,14,50,18)
        term.setCursorPos(4,16)
        print("Disk Drive: ")
        term.setCursorPos(16,16)
        if drive ~= nil then
            term.setTextColor(colors.green)
            print("Online")
            term.setTextColor(colors.black)
        else
            term.setTextColor(colors.red)
            print("Offline")
            term.setTextColor(colors.black)
        end
        term.setCursorPos(24,16)
        perps = peripheral.getNames()
        print("Periphs Amount:", #perps)
        
        if selected == 1 then
            drawSelection(2,2,15,6,true)
            term.setCursorPos(4,4)
            print("Add Group")

            drawSelection(19,2,33,6,false)
            term.setCursorPos(21,4)
            print("List Periphs")

            drawSelection(37,2,50,6,false)
            term.setCursorPos(39,4)
            print("Del Periph")

            drawSelection(2,8,15,12,false)
            term.setCursorPos(4,10)
            print("Link Disk")

            drawSelection(19,8,33,12,false)
            term.setCursorPos(21,10)
            print("Unlink Disk")


        elseif selected == 2 then
            drawSelection(2,2,15,6,false)
            term.setCursorPos(4,4)
            print("Add Group")

            drawSelection(19,2,33,6,true)
            term.setCursorPos(21,4)
            print("List Periphs")

            drawSelection(37,2,50,6,false)
            term.setCursorPos(39,4)
            print("Del Periph")

            drawSelection(2,8,15,12,false)
            term.setCursorPos(4,10)
            print("Link Disk")

            drawSelection(19,8,33,12,false)
            term.setCursorPos(21,10)
            print("Unlink Disk")


        elseif selected == 3 then
            drawSelection(2,2,15,6,false)
            term.setCursorPos(4,4)
            print("Add Group")

            drawSelection(19,2,33,6,false)
            term.setCursorPos(21,4)
            print("List Periphs")

            drawSelection(37,2,50,6,true)
            term.setCursorPos(39,4)
            print("Del Periph")

            drawSelection(2,8,15,12,false)
            term.setCursorPos(4,10)
            print("Link Disk")

            drawSelection(19,8,33,12,false)
            term.setCursorPos(21,10)
            print("Unlink Disk")

            elseif selected == 4 then
            drawSelection(2,2,15,6,false)
            term.setCursorPos(4,4)
            print("Add Group")

            drawSelection(19,2,33,6,false)
            term.setCursorPos(21,4)
            print("List Periphs")

            drawSelection(37,2,50,6,false)
            term.setCursorPos(39,4)
            print("Del Periph")

            drawSelection(2,8,15,12,true)
            term.setCursorPos(4,10)
            print("Link Disk")

            drawSelection(19,8,33,12,false)
            term.setCursorPos(21,10)
            print("Unlink Disk")

            elseif selected == 5 then
            drawSelection(2,2,15,6,false)
            term.setCursorPos(4,4)
            print("Add Group")

            drawSelection(19,2,33,6,false)
            term.setCursorPos(21,4)
            print("List Periphs")

            drawSelection(37,2,50,6,false)
            term.setCursorPos(39,4)
            print("Del Periph")

            drawSelection(2,8,15,12,false)
            term.setCursorPos(4,10)
            print("Link Disk")

            drawSelection(19,8,33,12,true)
            term.setCursorPos(21,10)
            print("Unlink Disk")

        end
        local event, key, is_held = os.pullEvent("key")

        if keys.getName(key) == "right" and selected < 5 then
            selected = selected + 1
        elseif keys.getName(key) == "left" and selected > 1 then
            selected = selected - 1
        elseif keys.getName(key) == "down" and selected < 3 then
            selected = selected + 3
        elseif keys.getName(key) == "up" and selected > 3 then
            selected = selected - 3
        elseif keys.getName(key) == "backspace" then
            break
        elseif keys.getName(key) == "enter" then
            if selected == 1 then
                addPeripheral()
            elseif selected == 2 then
                listPeripheral()
            elseif selected == 3 then
                deletePeripheral("peripherals.txt")
            elseif selected == 4 then
                addDrive()
                setDrive()
            elseif selected == 5 then
                deletePeripheral("drive.txt")
                setDrive()
            end
        end
        sleep(0.1)
    end
end

function addPeripheral()
    local peripheralfile = fs.open("peripherals.txt", "r")
        local all = peripheral.getNames()
        local total = {}
        local amount = 1

        while true do
            local line = peripheralfile.readLine()
            if not line or line == "nil" then
                peripheralfile.close()
                break
            end
            total[amount] = line
            amount = amount + 1
        end
        while true do
            local continue = setListPages(all, "Choose Peripheral")
            if continue ~= -1 then
                local line1 = ""
                local line2 = all[continue]
                drawFullScreen()
                term.setCursorPos(4,4)
                print("Name Peripheral Group:")
                term.setCursorPos(4,5)
                line1 = read()
                local line = line1 .. "." .. line2
                local perip = fs.open("peripherals.txt","w")
                local print = 1
                for i = 1, #total + 1 do
                    if i ~= #total + 1 and total[i] ~= "" then
                        perip.writeLine(total[print])
                        print = print + 1
                    elseif i == #total + 1 and total[i] ~= "" then
                        perip.writeLine(line)
                    end
                end
                perip.close()
                break
            end
            sleep(0.1)
        end
    end

function listPeripheral()

    local peripherals = {}
    local slot = 1
        
    drawFullScreen()
    local peripheralfile = fs.open("peripherals.txt", "r") 
    while true do
        local line = peripheralfile.readLine()
        if not line then
            peripheralfile.close()
            break
        end
        peripherals[slot] = line
        slot = slot + 1
    end
    for i = 1, #peripherals do
        if i <= 14 then
            term.setCursorPos(4,3+i)
            print(peripherals[i])

        elseif 14 < i <= 28 then
            term.setCursorPos(20,3+i-14)
            print(peripherals[i])

        elseif 28 < i <= 42 then
            term.setCursorPos(36,3+i-28)
            print(peripherals[i])
        end
    end
    while true do
        local event, key, is_held = os.pullEvent("key")
        if keys.getName(key) == "backspace" then
            break
        end
    end
end

function deletePeripheral(file)

    local peripherals = {}
    local slot = 1
        
    drawFullScreen()
    local peripheralfile = fs.open(file, "r") 
    while true do
        local line = peripheralfile.readLine()
        if not line or line == "" then
            peripheralfile.close()
            break
        end
        peripherals[slot] = line
        slot = slot + 1
    end
    while true do
        local continue = setListPages(peripherals,"Select Peripheral:")
        if continue ~= -1 then
            peripherals[continue] = "nil"
            local perip = fs.open(file,"w")
                for i = 1, #peripherals + 1 do
                    if i < #peripherals + 1 and peripherals[i] ~= "nil" then
                        perip.writeLine(peripherals[i])
                    elseif i == #peripherals + 1 then
                        perip.writeLine("")
                    end
                end
                perip.close()
                reset = true
                break
        end
    end
end

function addDrive()
    drawFullScreen()
    
        local all = {peripheral.getName(peripheral.find("drive"))}
        local avaiable = {}
        local space = 1

        for i = 1, #all do
            for j = 1, #drive do
                if all[i] == drive[j] then
                    all[i] = "nil"
                end
            end
        end
        for i = 1, #all do
            if all[i] ~= "nil" then
                avaiable[space] = all[i]
                space = space + 1  
            end
        end
        if not avaiable[1] then
            term.setCursorPos(4,4)
            print("No Drives Avaiable")
            sleep(3)
        else
            local selected = setListPages(avaiable,"Choose Drive:")
            local file = fs.open("drive.txt", "w")
            local print = 1
            for i = 1, #drive + 1 do
                if i ~= #drive + 1 and drive[i] ~= "" then
                    file.writeLine(drive[print])
                    print = print + 1
                elseif i == #drive + 1 and drive[i] ~= "" then
                    file.writeLine(avaiable[selected])
                end
            end
        end
end

function backupHud()
    local selected = 1

    while true do
        drawScreen(2,14,50,18)
        if selected == 1 then
            drawSelection(2,2,15,6,true)
            term.setCursorPos(6,4)
            print("Backup")

            drawSelection(19,2,33,6,false)
            term.setCursorPos(22,4)
            print("Add BList")

            drawSelection(37,2,50,6,false)
            term.setCursorPos(40,4)
            print("Del BList")

        elseif selected == 2 then
            drawSelection(2,2,15,6,false)
            term.setCursorPos(6,4)
            print("Backup")

            drawSelection(19,2,33,6,true)
            term.setCursorPos(22,4)
            print("Add BList")

            drawSelection(37,2,50,6,false)
            term.setCursorPos(40,4)
            print("Del BList")

        elseif selected == 3 then
            drawSelection(2,2,15,6,false)
            term.setCursorPos(6,4)
            print("Backup")

            drawSelection(19,2,33,6,false)
            term.setCursorPos(22,4)
            print("Add BList")

            drawSelection(37,2,50,6,true)
            term.setCursorPos(40,4)
            print("Del BList")

        end
        local event, key, is_held = os.pullEvent("key")

        if keys.getName(key) == "right" and selected < 3 then
            selected = selected + 1
        elseif keys.getName(key) == "left" and selected > 1 then
            selected = selected - 1
        elseif keys.getName(key) == "down" and selected < 0 then
            selected = selected + 3
        elseif keys.getName(key) == "up" and selected > 3 then
            selected = selected - 3
        elseif keys.getName(key) == "backspace" then
            break
        elseif keys.getName(key) == "enter" then
            if selected == 1 then
                changeBackup()
            elseif selected == 2 then
                addBlacklist()
            elseif selected == 3 then
                deleteBlacklist()
            end
        end
        sleep(0.1)
    end
end

function changeBackup()
    local types = {"Item", "Fluid"}
    drawFullScreen()
    while true do
    local selected = setListPages(types, "Select Type:",true)
        if selected == -1 then
            break
        elseif types[selected] ~= "" then
            local list = searchPeripheralFile("blacklist.txt")
            local chosen = selectIOList(list, "Choose Peripherals")
            if types[selected] == "Item" then
                settings.set("Item.setting", chosen)
                settings.save()
                reset = true
            else
                settings.set("Liquid.setting", chosen)
                settings.save()
                reset = true
            end
            break
        end
    end
end

function addBlacklist()
    local line = ""
    local save = true
    local loop = 1
    local total = {}
    
    drawFullScreen()
    term.setCursorPos(4,4)
    print("Name Block to Blacklist:")
    term.setCursorPos(4,5)
    line = read()

    drawScreen(2,2,50,7)
    while true do
            term.setCursorPos(4,4)
            print("Save as", line, "?")
            term.setCursorPos(4,5)
            if save == true then
                print("> Save")
                term.setCursorPos(12,5)
                print("  Cancel")
            else
                print("  Save")
                term.setCursorPos(12,5)
                print("> Cancel")
            end
        local event, key, is_held = os.pullEvent("key")
            if keys.getName(key) == "left" and save== false then
                save = true
            elseif keys.getName(key) == "right" and save == true then
                save = false
            elseif keys.getName(key) == "backspace" then
                save = false
                break
            elseif keys.getName(key) == "enter" then
                break
            end
    end
    if save == true then
        local blacklistr = fs.open("blacklist.txt","r")
        while true do
            local subline = blacklistr.readLine()
            if not subline then
                blacklistr.close()
                break
            end
            if subline ~= "" then
                total[loop] = subline
                loop = loop + 1
            end
        end
        local blacklistw = fs.open("blacklist.txt","w")
        for i = 1, #total + 1 do
            if i < #total + 1 then
                blacklistw.writeLine(total[i])
            else 
                blacklistw.writeLine(line)
            end
        end
        blacklistw.close()
    end
end

function deleteBlacklist()

    local blacklist = {}
    local slot = 1
    local page = 1
        
    drawFullScreen()
    local file = fs.open("blacklist.txt", "r") 
    while true do
        local line = file.readLine()
        if not line or line == "" then
            file.close()
            break
        end
        blacklist[slot] = line
        slot = slot + 1
    end
    while true do
        local selected = setListPages(blacklist,"Select Blacklist:",true)
        if blacklist[selected] ~= "" then
            if selected ~= 1 and selected ~= 2 and selected ~= 3 then
            blacklist[selected] = "nil"
            local perip = fs.open("blacklist.txt","w")
                for i = 1, #blacklist + 1 do
                    if i < #blacklist + 1 and blacklist[i] ~= "nil" then
                        perip.writeLine(blacklist[i])
                    elseif i == #blacklist + 1 then
                        perip.writeLine("")
                    end
                end
                perip.close()
                break
            elseif selected == -1 then
                break
            else
                term.setCursorPos(4,1)
                print("You can't delete a Default Blacklist!")
                sleep(3)
                drawFullScreen()
            end
        end
    end
end

function runChains()
    setDrive()
    local submodes = {}
    while drive ~= nil do
        local slot = 1
        local submodefile = fs.open("submodes.txt", "r")
        while true do
        local line = submodefile.readLine()
            if not line or line == "nil" then
                submodefile.close()
                break
            end
            submodes[slot] = line
            slot = slot + 1
        end
        runGroup(submodes)
        if reset == true then
            reset = false
            clearObjects(searchPeripheralFile("blacklist.txt",true),settings.get("Item.setting"), settings.get("Liquid.setting"))
        end
        sleep(0.1)
    end
end

function runGroup(list)
    local mainmodes = {{".Mix",runMix},{".FluidMix",runFluidMix},{".Craft",runCraft},{".Transfer",runTransfer}}
        if drive[1] ~= "" then
            local command = {}
            local point = 0
                    for j = 1, #list do
                        local selected = list[j]
                        if selected ~= nil or selected ~= "" then
                            for k = 1, string.len(selected) do
                                if string.sub(selected,k,k) == "." then
                                        point = k
                                    break
                                end
                            end
                        end
                        for l = 1, #mainmodes do
                            if selected ~= nil then
                                if string.sub(selected,point) == mainmodes[l][1] then
                                    table.insert(command, function() retainer(mainmodes[l][2],selected) end)
                                end
                            end
                        end
                    end
            parallel.waitForAny(function() while reset == false do sleep(0.1) end end, table.unpack(command))
        end
end

function retainer(func, mode)
    local mark = 1
    local setfiles = {}
    if drive[1] ~= "" then
        for i = 1, #drive-1 do
                local mount = peripheral.wrap(drive[i])
                local path = mount.getMountPath() 
                local files = fs.list(path)
                for k = 1, #files do
                    local setpath = path .. "/" .. files[k]
                    local file = fs.open(setpath, "r")
                    local setmode = file.readLine()
                    file.close()
                    if setmode == mode then
                        setfiles[mark] = setpath
                        mark = mark + 1
                    end
                end
        end
        while true do
            for l = 1, #setfiles do
                if setfiles[l] ~= "" then
                    local check = func(setfiles[l])
                    if check == false then
                        setfiles[l] = ""
                    end
                end
            end
            sleep(0.1)
        end
    end
    print(mode)
end

function runMix(path)
    local ingredient = {}
    local slot = 1
    local amount = 0
    local correct = true
    local stopped = true
    local machines = 1
    if path ~= "" then
        local file = fs.open(path, "r")
        file.readLine()

        while true do
            local variable = file.readLine()
            local marker = 0
            if variable == "" then
                break
            end
            for i = 1, string.len(variable) do
                if string.sub(variable,i,i) == "^" then
                    marker = i
                    break
                end
            end
            local item = string.sub(variable,1,marker-1)
            local amount = string.sub(variable,marker+1)
            ingredient[slot] = {item, amount}
            slot = slot + 1
        end

        local Input = groupCheck(file.readLine(),path)
        if Input == false then
            return false
        end
        local InputList = {}
        for i = 1, #Input do
            InputList[i] = peripheral.wrap(Input[i])
        end
        local InMachine = groupCheck(file.readLine(),path)
        if InMachine == false then
            return false
        end
        local InMachineList = {}
        for k = 1, #InMachine do
            InMachineList[k] = peripheral.wrap(InMachine[k])
        end
        local OutMachine = groupCheck(file.readLine(),path)
        if OutMachine == false then
            return false
        end
        local OutMachineList = {}
        for l = 1, #OutMachine do
            OutMachineList[l] = peripheral.wrap(OutMachine[l])
        end
        local Output = groupCheck(file.readLine(),path)
        if Output == false then
            return false
        end
        local OutputList = {}
        for m = 1, #Output do
            OutputList[m] = peripheral.wrap(Output[m])
        end
        file.readLine()
        local Result = file.readLine()
        local Max = file.readLine()
        file.close()

        if pcall(function() local a = OutputList[1].list() end) == false then
            errorHandler("Output is not Inventory", path)
            return false
        end
        for i = 1, #OutputList do
            for slot, item  in pairs(OutputList[i].list()) do
                if item.name == Result then
                    amount = amount + item.count
                end
            end
        end
        if pcall(function() local a = Max+0 end) == false then
            errorHandler("Desired Isnt a Number", path)
            return false
        end
        if amount < Max+0 then
            local used = Max+0-amount
            if used < #InMachineList then
                machines = used
            else
                machines = #InMachineList
            end
                for k = 1, #ingredient do
                    local count = 0
                    for l = 1, #InputList do
                        for slot, item in pairs(InputList[l].list()) do
                            if item.name == ingredient[k][1] then
                                count = count + item.count
                            end
                        end
                    end
                    if ingredient[k][2]*machines > count then
                        if ingredient[k][2]+0 > count then
                            correct = false
                        else
                            machines = count/ingredient[k][2]
                        end
                    end
                end
                if correct ~= false then
                    for k = 1, #ingredient do
                        subInsertItem(InputList,machines,InMachineList,ingredient[k][2],ingredient[k][1],path)
                    end
                else
                    stopped = false
                end
            if pcall(function() local a = OutMachineList[1].getItemDetail(1) end) == false then
                errorHandler("No Machine Output avaiable", path)
                return false
            end
            local templist = OutMachineList[machines].getItemDetail(1)
            while stopped == true do
                local check = OutMachineList[machines].getItemDetail(1)
                if templist ~= nil then
                    if check == nil or templist.name ~= check.name then
                    subTransferItem(OutMachineList,machines,OutputList,Max,Result,path)
                    return true
                    end
                elseif templist == nil and check ~= nil then
                    subTransferItem(OutMachineList,machines,OutputList,Max,Result,path)
                    return true
                end
            end
        end
    end
end

function runCraft(path)
    local chosen = {}
    local amount = 0
    local shape = {}
    local variables = {}
    local check = {}
    local table = {}
    local count = 0
    local correct = true

    if path ~= "" then
        local file = fs.open(path, "r")
        file.readLine()
        local recipe = file.readLine()
        if recipe == "XX" or recipe == "XXXXXXXXXXX" then
            errorHandler("Recipe is not valid", path)
            return false
        end
        for i = 1, string.len(recipe) do
                local letter = string.sub(recipe,i,i)
                shape[#shape+1] = letter
            end
            while true do
                local variable = file.readLine()
                if variable == "" then
                    break
                end
                variables[#variables+1] = variable
            end

        local Input = groupCheck(file.readLine(),path)
        local InputList = {}
        for i = 1, #Input do
            InputList[i] = peripheral.wrap(Input[i])
        end
        local Turtle = peripheral.wrap(file.readLine())
        local Output = groupCheck(file.readLine(),path)
        local OutputList = {}
        for i = 1, #Output do
            OutputList[i] = peripheral.wrap(Output[i])
        end
        file.readLine()
        local Per = file.readLine()
        local Result = file.readLine()
        local Max = file.readLine()
        file.close()
        
        for i = 1, #OutputList do
            for slot, item  in pairs(OutputList[i].list()) do
                if item.name == Result then
                    amount = amount + item.count
                end
            end
        end
        if pcall(function() local a = Max+0 end) == false then
            errorHandler("Desired Isnt a Number", path)
            return false
        end
        if amount < Max+0 then
            for a = 1, #shape do
                for b = 1, #variables do
                    if check[b] == nil then
                        check[b] = {string.sub(variables[b], 5, string.len(variables[b])), 0}
                    end
                    if string.sub(variables[b], 1,1) == shape[a] then
                        table[a] = string.sub(variables[b], 5, string.len(variables[b]))
                        if string.sub(variables[b],1,1) ~= "X" then
                            check[b][2] = check[b][2] + 1
                        end
                    end
                end
            end
            for c = 1, #check-1 do
                for d = 1, #InputList do
                    for slot, item in pairs(InputList[d].list()) do
                        if item.name == check[c][1] then
                            count = count + item.count
                        end
                    end
                end
                    if check[c][1] ~= "" and (check[c][2]*Per+0) > count then
                        correct = false
                    end
                    count = 0
                end
            if correct ~= false  then
                for j = 1, #table do 
                    if table[j] ~= "nil" then
                            for d = 1, #InputList do
                                if chosen[1] == nil or chosen[1] == -1 then
                                    for slot, item in pairs(InputList[d].list()) do
                                        if item.name == table[j] then
                                            chosen = {d, slot}
                                            break
                                        else
                                            chosen = {-1, -1}
                                        end
                                    end
                                end
                            end
                            if chosen[2] ~= -1 then
                                InputList[chosen[1]].pushItems(peripheral.getName(Turtle),chosen[2],Per+0,j)
                            else
                                break
                            end
                            chosen[1] = -1
                        end
                    end
                end
            end

            local message = transmitTurtle()

            for i = 1, #OutputList do
                for j = 1, 12 do
                    local remaining = OutputList[i].pullItems(peripheral.getName(Turtle),j)
                    if remaining == 0 and j == 4 then
                        message = false
                    end
                end
            end
            if message == false then
                errorHandler("Unable to Craft", path)
                return false
            end
        end
    end

function runFluidMix(path)
    local ingredienti = {}
    local ingredientl = {}
    local slot = 1
    local amount = 0
    local correct = true
    local stopped = true
    local machines = 1

    if path ~= "" then
        local file = fs.open(path, "r")
        file.readLine()

        while true do
            local variable = file.readLine()
            local marker = 0
            if variable == "" then
                break
            end
            for i = 1, string.len(variable) do
                if string.sub(variable,i,i) == "^" then
                    marker = i
                    break
                end
            end
            local item = string.sub(variable,1,marker-1)
            local amount = string.sub(variable,marker+1)
            ingredienti[slot] = {item, amount}
            slot = slot + 1
        end
        slot = 1
        while true do
            local variable = file.readLine()
            local marker = 0
            if variable == "" then
                break
            end
            for i = 1, string.len(variable) do
                if string.sub(variable,i,i) == "^" then
                    marker = i
                    break
                end
            end
            local item = string.sub(variable,1,marker-1)
            local amount = string.sub(variable,marker+1)
            ingredientl[slot] = {item, amount}
            slot = slot + 1
        end
        local Inputi = groupCheck(file.readLine(),path)
        if Inputi == false then
            return false
        end
        local InputiList = {}
        for i = 1, #Inputi do
            InputiList[i] = peripheral.wrap(Inputi[i])
        end
        local Inputl = groupCheck(file.readLine(),path)
        if Inputl == false then
            return false
        end
        local InputlList = {}
        for j = 1, #Inputl do
            InputlList[j] = peripheral.wrap(Inputl[j])
        end
        local InMachine = groupCheck(file.readLine(),path)
        if InMachine == false then
            return false
        end
        local InMachineList = {}
        for k = 1, #InMachine do
            InMachineList[k] = peripheral.wrap(InMachine[k])
        end
        local OutMachine = groupCheck(file.readLine(),path)
        if OutMachine == false then
            return false
        end
        local OutMachineList = {}
        for l = 1, #OutMachine do
            OutMachineList[l] = peripheral.wrap(OutMachine[l])
        end
        local Output = groupCheck(file.readLine(),path)
        if Output == false then
            return false
        end
        local OutputList = {}
        for m = 1, #Output do
            OutputList[m] = peripheral.wrap(Output[m])
        end
        file.readLine()
        local Result = file.readLine()
        local desired = file.readLine()
        file.close()

        if pcall(function() local a = OutputList[1].list() end) == false and pcall(function() local a = OutputList[1].tanks() end) == false then
            errorHandler("Output is not Compatible", path)
            return false
        end
            if pcall(function() OutputList[1].list() end) then
                for slot, item in pairs(OutputList[1].list()) do
                    if item.name == Result then
                        amount = amount + item.count
                    end
                end
            elseif pcall(function() OutputList[1].tanks() end) then
                for slot, fluid in pairs(OutputList[1].tanks()) do
                    if fluid.name == Result then
                        amount = amount + fluid.amount
                    end
                end
            end
            if pcall(function() local a = desired+0 end) == false then
                errorHandler("Desired Isnt a Number", path)
                return false
            end
                if amount < desired+0 then
                    local used = desired+0 - amount
                    if used < #InMachineList then
                        machines = used
                    else
                        machines = #InMachineList
                    end
                    for j = 1, #InputiList do
                        for k = 1, #ingredienti do
                            local count = 0
                            for slot, item in pairs(InputiList[j].list()) do
                                if item.name == ingredienti[k][1] then
                                    count = count + item.count
                                end
                            end
                            if ingredienti[k][2]*machines > count then
                                if ingredienti[k][2]+0 > count then
                                    correct = false
                                else
                                    machines = count/ingredienti[k][2]
                                end
                            end
                        end
                    end
                    for l = 1, #ingredientl do
                        local count = 0
                        for m = 1, #InputlList do
                            for slot, fluid in pairs(InputlList[m].tanks()) do
                                if fluid.name == ingredientl[l][1] then
                                    count = count + fluid.amount
                                end
                            end
                        end
                        if ingredientl[l][2]*machines > count then
                            if ingredientl[l][2]+0 > count then
                                correct = false
                            else
                                machines = count/ingredientl[l][2]
                            end
                        end
                    end
                    if correct ~= false then
                        for l = 1, #ingredienti do
                            subInsertItem(InputiList,#InputiList,InMachineList,ingredienti[l][2],ingredienti[l][1],path)
                        end
                        for m = 1, #ingredientl do
                            subTransferFluid(InputlList,#InputlList,InMachineList,ingredientl[m][2],ingredientl[m][1],path)
                        end
                    else
                        stopped = false
                    end
            if pcall(function() local a = OutMachineList[1].getItemDetail(1) end) == false then
                errorHandler("No Machine Output avaiable", path)
                return false
            end
            local templist = OutMachineList[machines].getItemDetail(1)
            while stopped == true do
                local check = OutMachineList[machines].getItemDetail(1)
                if templist ~= nil then
                    if check == nil or templist.name ~= check.name then
                        if pcall(function() OutputList[1].list() end) then
                            local item = subTransferItem(OutMachineList, machines, OutputList, desired, Result, path)
                            if item == false then
                                return false
                            end                        
                        end
                        if pcall(function() OutputList[1].tanks() end) then
                            local fluid = subTransferFluid(OutMachineList, machines, OutputList, desired, Result, path)
                            if fluid == false then
                                return false
                            end
                        end
                        stopped = false
                    end
                elseif temptlist == nil and check ~= nil then
                        if pcall(function() OutputList[1].list() end) then
                            local item = subTransferItem(OutMachineList, machines, OutputList, desired, Result, path)
                            if item == false then
                                return false
                            end                        
                        end
                        if pcall(function() OutputList[1].tanks() end) then
                            local fluid = subTransferFluid(OutMachineList, machines, OutputList, desired, Result, path)
                            if fluid == false then
                                return false
                            end
                        end
                        stopped = false
                    end
                end
            end
        end
    end

function runTransfer(path)

    if path ~= "" or not path then
        local file = fs.open(path, "r")
        file.readLine()

        local variable = file.readLine()
        local desired = file.readLine()
        file.readLine()
        local Input = groupCheck(file.readLine(),path)
        local InputList = {}
        for i = 1, #Input do
            InputList[i] = peripheral.wrap(Input[i])
        end
        local ISlot = file.readLine()
        local Output = groupCheck(file.readLine(),path)
        local OutputList = {}
        for j = 1, #Output do
            OutputList[j] = peripheral.wrap(Output[j])
        end
        local OSlot = file.readLine()

        if pcall(function () OutputList[1].list() end) then
            if not OSlot then
                local item = subTransferItem(InputList, #InputList, OutputList, desired, variable, path)
                if item == false then
                    return false
                end
            else
                local item = subTransferSlot(InputList, #InputList, OutputList, desired, variable, OSlot, path)
                if item == false then
                    return false
                end
            end
        elseif pcall(function () OutputList[1].tanks() end) then
            local fluid = subTransferFluid(InputList, #InputList, OutputList, desired, variable, path)
            if fluid == false then
                return false
            end
        else
            errorHandler("Error:Output isnt Item or Fluid!", path)
            return false
        end
        return true
    end
end

function subTransferItem(input, machines, output, desired, variable, path)
    local amount = 0
            if pcall(function() input[1].size() end) then
                for l = 1, #output do
                    for slot, item  in pairs(output[l].list()) do
                        if item.name == variable then
                            amount = amount + item.count
                        end
                    end
                end
                if amount < desired+0 then
                    for j = 1, machines do
                        for k = 1, #output do
                            for i = 1, input[1].size() do
                                local spot = input[j].getItemDetail(i)
                                if spot ~= nil then
                                    if spot.name == variable then
                                        local call = output[k].pullItems(peripheral.getName(input[j]),i,desired+0)
                                        desired = desired - call
                                        if call == 0 then
                                            break
                                        elseif desired <= 0 then
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                errorHandler("Input isnt Inventory", path)
                return false
            end
end

function subTransferFluid(input, machines, output, desired, variable, path)
    local amount = 0
    local tanks = 1
            if pcall(function() input[1].tanks() end) then
                for l = 1, #output do
                    for slot, fluid  in pairs(output[l].tanks()) do
                        tanks = tanks + 1
                        if fluid.name == variable then
                            amount = amount + fluid.amount
                        end
                    end
                end
                if tanks > 1 then
                    tanks = tanks - 1
                end
                if amount < desired+0 then
                    for i = 1, machines do
                        for k = 1, #output do
                                local call = output[k].pullFluid(peripheral.getName(input[i]),desired+0,variable)
                                desired = desired - call
                                if call == 0 then
                                    break
                                elseif desired <= 0 then
                                    return
                                end
                        end
                    end
                end
            else
                errorHandler("Input isnt Fluid", path)
                return false
            end
end

function subInsertItem(input, machines, output, desired, variable, path)
    local amount = 0
    local chosen = 0
    local set = desired * machines
    desired = desired * machines
        if pcall(function() input[1].size() end) then
            for l = 1, #output do
                for slot, item  in pairs(output[l].list()) do
                    if item.name == variable then
                        amount = amount + item.count
                    end
                end
            end
            for i = 1, #input do
                for slot, item  in pairs(input[i].list()) do
                    if item.name == variable then
                        chosen = slot
                    end
                end
            end
            if amount < desired then
                for j = 1, #input do
                    for k = 1, machines do
                        local call = output[k].pullItems(peripheral.getName(input[j]),chosen,set/machines)
                        desired = desired - call
                        if call == 0 then
                            break
                        end
                    end
                end
            end
        else
            errorHandler("Input isnt Inventory", path)
            return false
        end
end

function subTransferSlot(input, machines, output, desired, variable, slot, path)
    local amount = 0
            if pcall(function() input[1].size() end) then
                for l = 1, #output do
                    for slot, item  in pairs(output[l].list()) do
                        if item.name == variable then
                            amount = amount + item.count
                        end
                    end
                end
                if amount < desired+0 then
                    for j = 1, machines do
                        for k = 1, #output do
                            for i = 1, input[1].size() do
                                local spot = input[j].getItemDetail(i)
                                if spot ~= nil then
                                    if spot.name == variable then
                                        local call = input[j].pushItems(peripheral.getName(output[k]),i,desired+0,slot+0)
                                        desired = desired - call
                                        if call == 0 then
                                            break
                                        elseif desired <= 0 then
                                            return
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            else
                errorHandler("Input isnt Inventory", path)
                return false
            end
            --2
end

function errorList()
    local files = {}
    local table = {}
    local list = fs.list("/errorlogs")
    local templist = {}
    for j = 1, #list do
        templist[j] = "/errorlogs/" .. list[j]
    end
        files = tableCombine(files,templist)
        while true do
            drawFullScreen()
            local selected = setListPages(files,"Choose Log:",true)
            if selected ~= -1 then
                local file = fs.open(files[selected], "r")
                local count = 0
                while true do
                    term.setCursorPos(4,4 + count)
                    local line = file.readLine()
                    count = count + 2
                    if not line or line == "" then
                        file.close()
                        break 
                    end
                    table[count] = line
                end
                readTable(table)
            else
                break
            end
        end
    end

function readTable(list)
    local slide = 1
    local max = (#list/10)+1

    drawScreen(2,2,50,20)
    for i = 1, 10 do
        term.setCursorPos(4,3 + i)
        if list[i] ~= nil then
            print(list[i])
        end
    end

    while true do
                    local event, key, is_held = os.pullEvent("key")
                    if keys.getName(key) == "backspace" or keys.getName(key) == "enter" then
                        break
                    elseif keys.getName(key) == "up" and slide == 2 then
                        drawScreen(2,2,50,20)
                        slide = slide - 1
                        for i = 1, 10 do
                            term.setCursorPos(4,3 + i)
                            if list[i] ~= nil then
                                print(list[i])
                            end
                        end
                    elseif keys.getName(key) == "up" and slide > 2 then
                        drawScreen(2,0,50,20)
                        slide = slide - 1
                        for i = 1, 10 do
                            term.setCursorPos(4,3 + i)
                            if list[(slide*10-1)+i] ~= nil then
                                print(list[(slide*10-1)+i])
                            end
                        end
                    elseif keys.getName(key) == "down" and slide < max then
                        drawScreen(2,0,50,20)
                        slide = slide + 1
                        for i = 1, 10 do
                            term.setCursorPos(4,3 + i)
                            if list[(slide*10-1)+i] ~= nil then
                                print(list[(slide*10-1)+i])
                            end
                        end
                    elseif keys.getName(key) == "down" and slide == max-1 then
                        drawScreen(2,0,50,18)
                        slide = slide + 1
                        for i = 1, 10 do
                            term.setCursorPos(4,3 + i)
                            if list[(slide*10-1)+i] ~= nil then
                                print(list[(slide*10-1)+i])
                            end
                        end
                    end
                end
end

function drawFullScreen()
    term.setBackgroundColor(colors.black)
    term.clear()
    paintutils.drawFilledBox(2,2,50,18,colors.white)
    paintutils.drawBox(2,2,50,18,colors.lightGray)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
end

function drawScreen(x1,y1,x2,y2)
    term.setBackgroundColor(colors.black)
    term.clear()
    paintutils.drawFilledBox(x1,y1,x2,y2,colors.white)
    paintutils.drawBox(x1,y1,x2,y2,colors.lightGray)
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
end

function drawSelection(x1,y1,x2,y2,chosen)
    paintutils.drawFilledBox(x1,y1,x2,y2,colors.white)
    if chosen == true then
        paintutils.drawBox(x1,y1,x2,y2,colors.lightGray)
    end
    term.setBackgroundColor(colors.white)
    term.setTextColor(colors.black)
end

function transmitTurtle()
    modem.open(1)
    modem.transmit(2,1,"craft")
    local event, side, channel, replyChannel, message, distance
    repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 1
    return message
end 

function searchPeripheralMenu(filter)
    local search = {}
    local full = {}
    local selected = 1
    
    for i = 1, #filter do
        if filter[i] ~= nil then
            search[i] = {peripheral.find(filter[i])}
        end
    end
    for j = 1, #search do
            full = tableCombine(full, search[j])
    end

    while true do
        --Bg
        drawFullScreen()

        --Search Results
        if full[1] ~= nil then
            for i = 1, #full, 1 do
                term.setCursorPos(3,2+i)
                if i == selected then
                    print(">",peripheral.getName(full[i]))
                else
                    print(" ",peripheral.getName(full[i]))
                end
            end
        else
            print("Error: No peripheral found!")
        end

        --Controls
        local event, key, is_held = os.pullEvent("key")
        if keys.getName(key) == "down" and selected < #search then
            selected = selected + 1
        elseif keys.getName(key) == "up" and selected > 1 then
            selected = selected - 1
        elseif keys.getName(key) == "enter" and #search > 0 then
            return peripheral.getName(search[selected])
        elseif keys.getName(key) == "backspace" then
            break
        end

    sleep(0.1)
    end
end

function searchPeripheral(filterlist, blacklist)
    local search = {}
    local full = {}
    local all = peripheral.getNames()
    local slot = 1

    for i = 1, #filterlist do
        if filterlist[i] ~= nil then
            search[i] = {peripheral.find(filterlist[i])}
        end
    end
    for j = 1, #search do
            tableCombine(full, search[j])
    end
    if not blacklist then
        return full
    else
        for k = 1, #all do
            for l = 1, #full do
                if all[k] == peripheral.getName(full[l]) then
                    all[k] = "nil"
                end
            end
        end
        full = {}
        for m = 1, #all do
            if all[m] ~= "nil" then
                full[slot] = all[m]
                slot = slot + 1
            end
        end
        return full
    end
end

function searchPeripheralFile(file, blacklist)
    local files = fs.open(file,"r")
    local search = {}
    local filter = {}
    local peripherals = {}
    local full = {}
    local all = peripheral.getNames()
    local slot = 1

    while true do
        local line = files.readLine()
        if not line then
            files.close()
            break
        end
        filter[slot] = line
        slot = slot + 1
    end

    for i = 1, #filter do
        if filter[i] ~= nil and pcall(function() peripheral.find(filter[i]) end) then
            search[i] = {peripheral.find(filter[i])}
        elseif filter[i] ~= nil and not pcall(function() peripheral.find(filter[i]) end) then
            for j = 1, #all do
                if all[j] == string.find(all[j],filter[i]) then
                    peripherals[j] = all[j]
                end
                search[i] = peripherals
            end
        end
    end

    for j = 1, #search do
            tableCombine(full, search[j])
    end
    if not blacklist then
        return full
    else
        for k = 1, #all do
            for l = 1, #full do
                if all[k] == peripheral.getName(full[l]) then
                    all[k] = "nil"
                end
            end
        end
        slot = 1
        full = {}
        for m = 1, #all do
            if all[m] ~= "nil" then
                full[slot] = all[m]
                slot = slot + 1
            end
        end
        return full
    end
end

function clearObjects(peripherals, inventory, fluid)
    local slot = 1
    local inv = groupCheck(inventory,"InventoryBackup")
    local invwrap = {}
    local flu = groupCheck(fluid,"FluidBackup")
    local fluwrap = {}

    if not inventory or inv[1] == "nil" then
        invwrap = searchPeripheral({"minecraft:chest"})
    else
        for i = 1, #inv do
            invwrap[i] = peripheral.wrap(inv[i])
        end 
    end
    if not fluid or flu[1] == "nil" then
        fluid = searchPeripheral({"create:fluid_tank"})
    else
        for i = 1, #flu do
            fluwrap[i] = peripheral.wrap(flu[i])
        end
    end
    for i = 1, #peripherals do
        local wrap = peripheral.wrap(peripherals[i])
        slot = 1
        if pcall(function() wrap.list() end)then
            for k = 1, wrap.size() do
                if wrap.getItemDetail(k) ~= nil then
                    local fill = invwrap[slot].pullItems(peripheral.getName(wrap), k)
                    if fill == 0 then
                        slot = slot + 1 
                        k = k - 1
                        if slot > #invwrap then
                            error("Backup Chests are Full, please empty!")
                        end
                    end
                end
            end
        end
        slot = 1
        if pcall(function() wrap.tanks() end) then
            if pcall(function() fluwrap[slot].pullFluid(peripheral.getName(wrap)) end) then
                while true do
                    local fill = fluwrap[slot].pullFluid(peripheral.getName(wrap))
                    local use = ""
                    local name = ""
                    for tank1, fluid1 in pairs(wrap.tanks()) do
                        use = fluid1.name
                    end
                    for tank2, fluid2 in pairs(fluwrap[slot].tanks()) do
                        name = fluid2.name
                    end
                    if use ~= "" then
                        if fill == 0 and name ~= use then
                            slot = slot+1
                            if slot > #fluid then
                                errorHandler("Backup Tanks are Full, please empty!","FluidBackup")
                                use = ""
                            end
                        end
                    else
                        break
                    end
                end
            else
                errorHandler("No Backup Fluid Avaiable", "FluidBackup")
            end
        end
    end
end

function selectIOList(list, string)
    local selected = 1
    local page = 1
    local max = (#list/10)+1
    if pcall(function () peripheral.getName(list[1]) end) then
        for j = 1, #list do
            list[j] = peripheral.getName(list[j])
        end
    end
    while #list > 0 do
        drawFullScreen()
        for i = 1, 10 do
            if i <= 10 and i <= #list and page == 1 then
                term.setCursorPos(4,4)
                print(string)
                term.setCursorPos(4,5)
                if selected == 1 then
                    print("Group.. <")
                else
                    print("Group..  ")
                end
                term.setCursorPos(4,5+i)
                if list[i+1] ~= nil then
                if i+1 == selected and list[i+1] ~= "" then
                    print(list[i], "<")
                else
                    print(list[i], " ")
                end
            end
            elseif page > 1 then
                term.setCursorPos(4,4)
                print(string)
                term.setCursorPos(4,4+i)
                if list[(page-1)*10+i] ~= nil then
                    if (page-1)*10+i == selected then
                        print(list[(page-1)*10+i], "<")
                    else
                        print(list[(page-1)*10+i], " ")
                    end
                end
            end
        end
        --Keypresses
        local event, key, is_held = os.pullEvent("key")
        if keys.getName(key) == "down" and selected < (page)*10 and selected < #list and page ~= 1 then
            selected = selected + 1
        elseif keys.getName(key) == "down" and selected < (page)*11 and selected < #list+1 and page == 1 then
            selected = selected + 1
        elseif keys.getName(key) == "up" and selected > (page-1)*10+1 then
            selected = selected - 1
        elseif keys.getName(key) == "left" and page > 1 then
            page = page - 1
            if page ~= 1 then
                selected = ((page - 1) * 11)
            else
                selected = 1
            end
        elseif keys.getName(key) == "right" and page < max-1 then
            page = page + 1
            if page ~= 1 then
                selected = ((page - 1) * 11)
            else
                selected = 1
            end
        elseif keys.getName(key) == "enter" then
            if selected == 1 then
                drawFullScreen()
                term.setCursorPos(4,4)
                print("Name Group:")
                term.setCursorPos(4,5)
                return read()
            elseif selected > 1 then
                return list[selected]
            end
        end
    end
end

function tableCombine(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function groupCheck(peripher, path)
    if peripher ~= nil then
        local list = {}
        local periph = peripheral.getNames()
        local count = 1
        for i = 1, #periph do
            if peripher == periph[i] then
                list[1] = peripher
                return list
            end
        end
        local files = fs.open("peripherals.txt","r")
        while true do
            local line = files.readLine()
            if line == "" or line == "nil" or not line then
                files.close()
                if list[1] == nil then
                    errorHandler("No Group Found", path)
                    return false
                end
                return list
            end
            if string.sub(line, 1, string.len(peripher)) == peripher then
                list[count] = string.sub(line, string.len(peripher)+2)
                count = count + 1
            end
        end
    else
        errorHandler("Peripheral doesn't exist!", path)
        return false
    end
end

function setListPages(list, string, bool)
    local selected = 1
    local page = 1
    local max = #list/10+1
    while true do
        drawFullScreen()
    for i = 1, 10 do
            if page == 1 then
                term.setCursorPos(4,4)
                print(string)
                term.setCursorPos(4,4+i)
                if list[i] ~= nil then
                    if i == selected then
                        print(list[i], "<")
                    else
                        print(list[i], " ")
                    end
                end
            elseif page > 1 and list[(page-1)*10+i] ~= "" then
                term.setCursorPos(4,4)
                print(string)
                term.setCursorPos(4,4+i)
                if list[(page-1)*10+i]  ~= nil then
                    if (page-1)*10+i == selected then
                        print(list[(page-1)*10+i] , "<")
                    else
                        print(list[(page-1)*10+i] , " ")
                    end
                end
            end
        end
        local event, key, is_held = os.pullEvent("key")
        if keys.getName(key) == "down" and selected < (page)*10 and selected < #list then
        selected = selected + 1
        elseif keys.getName(key) == "up" and selected > (page-1)*10+1 then
        selected = selected - 1
        elseif keys.getName(key) == "left" and page > 1 then
        page = page - 1
        if page ~= 1 then
            selected = ((page - 1) * 11)
        else
            selected = 1
        end
        elseif keys.getName(key) == "right" and page < max-1 then
        page = page + 1
        if page ~= 1 then
            selected = ((page - 1) * 11)
        else
            selected = 1
        end
        elseif keys.getName(key) == "enter" then
            return selected
        elseif keys.getName(key) == "backspace" and bool == true then
            return -1
        end
    end
end

function errorHandler(err, path)
    local log = fs.open(errorfile, "r")
    local table = {}
    local number = 0
    local string = path .. " : " .. err
    while true do
        local line = log.readLine()
        number = number + 1
        if not line or line == "" then
            log.close()
            break
        end
        table[number] = line
    end
    table[number] = string
    local updatedlog = fs.open(errorfile, "w")
    for i = 1, #table do
        updatedlog.writeLine(table[i])
    end
    updatedlog.close()
    erroramount = erroramount + 1
end

--MainLine
setFiles()
clearObjects(searchPeripheralFile("blacklist.txt",true),settings.get("Item.setting"), settings.get("Liquid.setting"))
parallel.waitForAny(systemHudSetup, runChains)
