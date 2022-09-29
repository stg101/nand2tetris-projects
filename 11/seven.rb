[[{:name=>"class",
   :code=>"class_L1",
   :values=>
    [{:name=>"keyword", :value=>"class"},
     {:name=>"className",
      :code=>"className_L2",
      :values=>
       [{:name=>"identifier",
         :code=>"identifier_L3",
         :values=>[{:name=>"identifier", :value=>"Main"}]}]},
     {:name=>"symbol", :value=>"{"},
     {:name=>"subroutineDec",
      :code=>"subroutineDec_L5",
      :values=>
       [{:name=>"keyword", :value=>"function"},
        {:name=>"keyword", :value=>"void"},
        {:name=>"subroutineName",
         :code=>"subroutineName_L6",
         :values=>
          [{:name=>"identifier",
            :code=>"identifier_L7",
            :values=>[{:name=>"identifier", :value=>"main"}]}]},
        {:name=>"symbol", :value=>"("},
        {:name=>"symbol", :value=>")"},
        {:name=>"subroutineBody",
         :code=>"subroutineBody_L12",
         :values=>
          [{:name=>"symbol", :value=>"{"},
           {:name=>"statements",
            :code=>"statements_L14",
            :values=>
             [{:name=>"statement",
               :code=>"statement_L15",
               :values=>
                [{:name=>"doStatement",
                  :code=>"doStatement_L19",
                  :values=>
                   [{:name=>"keyword", :value=>"do"},
                    {:name=>"subroutineCall",
                     :code=>"subroutineCall_L20",
                     :values=>
                      [{:name=>"className",
                        :code=>"className_L23",
                        :values=>
                         [{:name=>"identifier",
                           :code=>"identifier_L24",
                           :values=>
                            [{:name=>"identifier", :value=>"Output"}]}]},
                       {:name=>"symbol", :value=>"."},
                       {:name=>"subroutineName",
                        :code=>"subroutineName_L25",
                        :values=>
                         [{:name=>"identifier",
                           :code=>"identifier_L26",
                           :values=>
                            [{:name=>"identifier", :value=>"printInt"}]}]},
                       {:name=>"symbol", :value=>"("},
                       {:name=>"expressionList",
                        :code=>"expressionList_L27",
                        :values=>
                         [{:name=>"expression",
                           :code=>"expression_L28",
                           :values=>
                            [{:name=>"term",
                              :code=>"term_L29",
                              :values=>
                               [{:name=>"integerConstant",
                                 :code=>"integerConstant_L30",
                                 :values=>
                                  [{:name=>"integerConstant", :value=>"1"}]}]},
                             {:name=>"op",
                              :code=>"op_L31",
                              :values=>[{:name=>"symbol", :value=>"+"}]},
                             {:name=>"term",
                              :code=>"term_L32",
                              :values=>
                               [{:name=>"symbol", :value=>"("},
                                {:name=>"expression",
                                 :code=>"expression_L47",
                                 :values=>
                                  [{:name=>"term",
                                    :code=>"term_L48",
                                    :values=>
                                     [{:name=>"integerConstant",
                                       :code=>"integerConstant_L49",
                                       :values=>
                                        [{:name=>"integerConstant",
                                          :value=>"2"}]}]},
                                   {:name=>"op",
                                    :code=>"op_L50",
                                    :values=>[{:name=>"symbol", :value=>"*"}]},
                                   {:name=>"term",
                                    :code=>"term_L51",
                                    :values=>
                                     [{:name=>"integerConstant",
                                       :code=>"integerConstant_L52",
                                       :values=>
                                        [{:name=>"integerConstant",
                                          :value=>"3"}]}]}]},
                                {:name=>"symbol", :value=>")"}]}]}]},
                       {:name=>"symbol", :value=>")"}]},
                    {:name=>"symbol", :value=>";"}]}]},
              {:name=>"statement",
               :code=>"statement_L55",
               :values=>
                [{:name=>"returnStatement",
                  :code=>"returnStatement_L60",
                  :values=>
                   [{:name=>"keyword", :value=>"return"},
                    {:name=>"symbol", :value=>";"}]}]}]},
           {:name=>"symbol", :value=>"}"}]}]},
     {:name=>"symbol", :value=>"}"}]}]]
{}
{}
