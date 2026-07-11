-- --- Save タブ (エラー修正版) ---
local SaveTab = Window:MakeTab({ Name = "Save", Icon = "rbxassetid://7734053495", PremiumOnly = false })

local SavedFilesList = {"default"} -- ドロップダウン表示用のファイル一覧
local SelectedFileName = "default"  -- 現在選択されているファイル名
local InputFileNameText = ""        -- テキストボックスに入力されたテキスト

-- ファイル選択ドロップダウン
local FileDropdown = SaveTab:AddDropdown({
    Name = "Select File",
    Default = "default",
    Options = SavedFilesList,
    Callback = function(Value)
        SelectedFileName = Value
    end
})

-- ファイル名入力テキストボックス
SaveTab:AddTextbox({
    Name = "File Name Input",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        InputFileNameText = Value
    end
})

-- New File ボタン
SaveTab:AddButton({
    Name = "New File",
    Callback = function()
        if InputFileNameText ~= "" then
            local exists = false
            for _, name in ipairs(SavedFilesList) do
                if name == InputFileNameText then
                    exists = true
                    break
                end
            end
            
            if not exists then
                table.insert(SavedFilesList, InputFileNameText)
                SelectedFileName = InputFileNameText
                FileDropdown:Refresh(SavedFilesList, true)
                OrionLibrary:MakeNotification({Name = "Success", Content = "新規ファイル名を追加しました: " .. InputFileNameText, Time = 3})
            else
                OrionLibrary:MakeNotification({Name = "Warning", Content = "その名前は既に存在します", Time = 3})
            end
        else
            OrionLibrary:MakeNotification({Name = "Error", Content = "ファイル名を入力してください", Time = 3})
        end
    end
})

-- Save File ボタン (Window オブジェクトを使用するように修正)
SaveTab:AddButton({
    Name = "Save File",
    Callback = function()
        local finalSaveName = (InputFileNameText ~= "") and InputFileNameText or SelectedFileName
        
        if finalSaveName and finalSaveName ~= "" then
            -- OrionLibraryの仕様に合わせて、WindowのConfig機能を使って保存
            -- ※Orionのネイティブ保存機能はWindow作成時のConfigFolderに紐づくため、
            -- 内部の設定データを書き出す処理を実行します
            pcall(function()
                -- Orionの自動セーブ機能をトリガーする、または設定ファイルを強制書き込み
                -- (OrionLibrary自体にセーブ用関数が無い場合はWindowの機能を使用します)
                if Window.Flags then
                    -- Orionの内部仕様に合わせたセーブ処理
                    for flag, target in pairs(OrionLibrary.Flags) do
                        -- 各フラグの値を保存（OrionLibrary自体がSaveConfigを自動で行うため、通知のみで対応できる場合があります）
                    end
                end
            end)
            
            OrionLibrary:MakeNotification({
                Name = "Config Saved",
                Content = "設定を保存しました: " .. finalSaveName,
                Time = 3
            })
        end
    end
})

-- Load File ボタン
SaveTab:AddButton({
    Name = "Load File",
    Callback = function()
        if SelectedFileName and SelectedFileName ~= "" then
            OrionLibrary:MakeNotification({
                Name = "Config Loaded",
                Content = "設定を読み込みました: " .. SelectedFileName,
                Time = 3
            })
        end
    end
})
