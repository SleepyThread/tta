class VisualizationController < ApplicationController

  def pyramid
    begin
      respond_to do |format|
        format.html
        format.json { render :json => @json }
      end
    end
  end

  def sub_project_filter
    sub_project_id=params[:sub_project][:id]
    sub_project = SubProject.find_by_id(sub_project_id)
    if sub_project_id.blank? || sub_project.nil?
      flash[:no_id_error] = "No Sub-Project Selected"
      flash[:no_test_error]=nil
    else
      @json = Visualization.getResultJson(sub_project_id)
      json_obj = JSON.parse!(@json)
      p "json obj:"
      json_obj["test_types"].each do |test_type|
         if test_type["percent"]
           flash[:no_test_error]="No test in your project!!"
         end
      end
      flash[:no_id_error]=nil
    end
  end
end