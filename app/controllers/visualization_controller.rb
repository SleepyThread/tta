class VisualizationController < ApplicationController

  def pyramid
  end

  def sub_project_filter
      sub_project_id=params[:sub_project][:id]
      if sub_project_id.blank?
        flash[:no_id_error] = "No Sub-Project Selected"
        flash[:no_test_error]=nil
        render 'visualization/pyramid'
     else
      result_set1 = Visualization.getNoOfTests(sub_project_id,"FUNCTIONAL TEST")
      result_set2 = Visualization.getNoOfTests(sub_project_id,"UNIT TEST")
      result_set3 = Visualization.getNoOfTests(sub_project_id,"INTEGRATION TEST")
      @no_of_unit_test = calculate_number_of_test(result_set2)
      @no_of_functional_test = calculate_number_of_test(result_set1)
      @no_of_Integration_test = calculate_number_of_test(result_set3)
      @sub_project_name = SubProject.find(sub_project_id).name

      calculate_percentage_of_tests
      @duration_functional=calculate_duration_in_hours(result_set1)
      @duration_unit=calculate_duration_in_hours(result_set2)
      @duration_integration=calculate_duration_in_hours(result_set3)
      flash[:no_id_error]=""
      render :pyramid
      end

  end

  def calculate_duration_in_hours(result_set)
    if(result_set != [])
      time = "%0.4f" % (result_set[0][1].to_f/60000)
      return time
    else
      return 0
    end

  end

  def calculate_percentage_of_tests
    flash[:no_test_error]=nil
    @total = @no_of_unit_test.to_f + @no_of_functional_test.to_f + @no_of_Integration_test.to_f
    if (@total==0)
      flash[:no_test_error]="No test in your project"
    end
    @percent_unit_test = "%0.2f" % ((@no_of_unit_test/@total) *100)
    @percent_functional_test = "%0.2f" % ((@no_of_functional_test/@total) *100)
    @percent_integration_test = "%0.2f" % ((@no_of_Integration_test/@total) *100)

  end

  def calculate_number_of_test(result_set)
    if(result_set != [])
      return result_set[0][0]
    else
      return 0
    end
  end

end
