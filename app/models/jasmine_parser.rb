class JasmineParser
  def self.parse(config_txt, meta_id, params)

    report_data = create_jasmine_data_array(config_txt)
    test_suite_summary =report_data.pop()
    # NEED TO CHECK LOGS ...
    save_jasmine_test_suite(meta_id, test_suite_summary)
    save_jasmine_test_cases(each_entry)
  end

  def self.save_jasmine_test_suite(meta_id, test_suite_summary)
    @jasmine_test_suite_data = TestSuiteRecord.new()
    @jasmine_test_suite_data.test_metadatum_id=meta_id
    @jasmine_test_suite_data.class_name="JasmineReports #{meta_id}"
    @jasmine_test_suite_data.number_of_tests=test_suite_summary[1]
    @jasmine_test_suite_data.number_of_errors=0
    @jasmine_test_suite_data.number_of_failures=test_suite_summary[2]
    @jasmine_test_suite_data.time_taken=test_suite_summary[3]
    @jasmine_test_suite_data.number_of_tests_ignored=0
    @jasmine_test_suite_data.number_of_tests_not_run=0
    @jasmine_test_suite_data.save
  end
end

def self.save_jasmine_test_cases(each_entry)
  report_data.each do |each_entry|

    @jasmine_test_case_data = TestCaseRecord.new()
    @jasmine_test_case_data.test_suite_record_id = @jasmine_test_suite_data.id
    @jasmine_test_case_data.class_name = each_entry[1]+each_entry[2]
    @jasmine_test_case_data.time_taken = 0.0
    if (each_entry[0]=="FAIL")
      @jasmine_test_case_data.error_msg = each_entry[3]
    end
    @jasmine_test_case_data.save
  end
end

def self.create_jasmine_data_array(config_txt)
  report = config_txt.split("\n");
  report_data=[]
  report.each do |data|
    report_data<< data.split("||");
  end
  report_data
end
