module Foobara
  module Util
    module_function

    # TODO: why do we have monorepo/project concerns reflected here?
    # TODO: get rid of this or move it to a Projects project
    def require_project_file(project, path)
      require_relative("../../#{project}/src/#{path}")
    end
  end
end
