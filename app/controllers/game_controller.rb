class GameController < ApplicationController
    def index
        @player_id = rand * 1000
        Score.create(playerid: @player_id, points: 0)
        @title = "WORD SCRAMBLER"
        @rule = "For every word unscrambled, the player will get 1 added point, and for every incorrect answer, the player will be deducted by 1 point"
        @rule2 = "if the player's points are zero, the game is over"        
        score
    end
    def score        
        sample = Word.all.sample        
        @scrambled_word = sample.keyword.chars.shuffle.join
        @word_id = sample.id        
        puts params
        if !params[:wordid].nil? 
            player = Score.find_by(playerid: params[:playerid])    
            word = Word.find(params[:wordid])            
            if word.keyword == params[:answer]
                output = "Congrats, your answer is right"
                points = player.points + 1
                player.update(points: points)
            else
                output = "Sorry, your answer is wrong"
                points = player.points - 1
                if points < 1
                    output = "game over" 
                end                
                player.update(points: points)
            end        
            puts output
            respond_to do |format|
                format.turbo_stream do
                render turbo_stream: turbo_stream.update("game", partial: "game/game",
                    locals: { player_id: player.playerid, points: player.points, score: output, scrambled_word: @scrambled_word, word_id: @word_id })
                end
        
                format.html { redirect_to 'score' }
            end
        end
    end


end