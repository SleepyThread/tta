class ComparativeAnalysis
  def get_result_set(sub_project_id, sub_category, start_date, end_date)
    sub_project=SubProject.find(sub_project_id)
    metadata_list = sub_project.test_metadatum
    test_category_mapping_list = metadata_list.select("distinct test_category,test_sub_category")
    if (!sub_category.nil?)
      test_category_mapping_list=test_category_mapping_list.where("test_sub_category IN (?)", sub_category)
    end
    result_set = Hash.new
    test_category_mapping_list.each { |test_category_mapping|
      metadata_records = metadata_list.where(:test_category => test_category_mapping.test_category, :test_sub_category => test_category_mapping.test_sub_category)
      metadata_records_for_selected_date_range = metadata_records.find_all_by_date_of_execution(start_date.beginning_of_day..end_date.end_of_day)
      aggregate_value = get_percentage_of_passing_tests(metadata_records_for_selected_date_range)
      test_category_and_sub_category = test_category_mapping.test_category + " : " +test_category_mapping.test_sub_category
      if aggregate_value != []
        result_set[test_category_and_sub_category] = aggregate_value
      end
    }
    return result_set
  end

  private
  def get_percentage_of_passing_tests(metadata_records)
    final_result = metadata_records.inject([]) { |result, metadata_record|
      test_report_type = metadata_record.test_report_type
      nunit_flag = test_report_type=="NUnit" ? 1 : 0
      number_of_failures, total_num_of_tests = (nunit_flag == 1 ? NunitParser.get_total_test_n_total_failure(metadata_record) : XmlParser.new.get_total_test_n_total_failure(metadata_record))
      total_num_of_tests!=0 ? result << [(metadata_record.date_of_execution.to_time.to_f * 1000), (total_num_of_tests.to_f - number_of_failures.to_f) / total_num_of_tests.to_f * 100] : result << []
    }
    final_result.delete([])
    return final_result.sort
  end
end