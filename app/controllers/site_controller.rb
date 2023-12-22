class SiteController < ApplicationController 

    def first
    end

    def second
    end 

    def third
        respond_to do |format|
            format.html { render :third_page }
            format.turbo_stream { head  Turbo::StreamsChannel.broadcast_update_to(
                "event_when_button_clicked",
                target: "content",
                partial: "site/dynamic_content",
                locals: {
                  my_value: 1000
                }
            )}
          end
    end

    def fourth
    end

    def fifth
      render turbo_stream: turbo_stream.update('hello_frame', partial: 'ajax_template')
    end
end