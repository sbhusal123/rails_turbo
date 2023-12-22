class SiteController < ApplicationController 

    def first
    end

    def second
    end    

    def third
        Turbo::StreamsChannel.broadcast_update_to("mystr", target: "content", partial: "site/streamed_stuff")
    end
end
