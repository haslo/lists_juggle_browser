module Generators
  module JSON
    class SquadronsGenerator
      class << self

        def generate_squadrons(context, squadrons)
          squadrons.map do |squadron|
            generate_squadron(context, squadron)
          end
        end

        private

        def generate_squadron(context, squadron)
          {
            id:   squadron.id,
            link: context.squadron_url(squadron.id, format: :json),
            xws:  squadron.xws,
          }
        end

      end
    end
  end
end
