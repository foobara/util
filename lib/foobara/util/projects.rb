module Foobara
  module Util
    module_function

    # TODO: why do we have monorepo/project concerns reflected here?
    # TODO: get rid of this or move it to a Projects project
    def require_project_file(project, path)
      # :nocov:
      require_relative("../../#{project}/src/#{path}")
      # :nocov:
    end
  end
end
