classes = if ActionPack::VERSION::MAJOR == 2
            [ActionController::Request, ActionController::CgiRequest]
          else
            [ActionDispatch::Request]
          end

classes.each { |c| c.send :include, HttpAcceptLanguage }
