#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param dms_token 口令
#' @param erp_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' DomesticCustomCreditViewServer()
DomesticCustomCreditViewServer <- function(input,output,session,dms_token,erp_token) {

  text_date_DomesticCustomCredit_FDate =tsui::var_date('text_date_DomesticCustomCredit_FDate')


  shiny::observeEvent(input$btn_DomesticCustomCredit_Measure,{
    FDate=text_date_DomesticCustomCredit_FDate()
    #清空DMS客户列表
    mdljhDomesticCustomCreditPkg::DomesticCustomCredit_customer_dms_delete(dms_token = dms_token)
    #清空ERP客户列表
    mdljhDomesticCustomCreditPkg::DomesticCustomCredit_customer_erp_delete(erp_token =erp_token )
    print(1)
    #获取收款退款
    data =mdljhDomesticCustomCreditPkg::DomesticCustomCredit_Receive_view(erp_token =erp_token ,FDate = FDate)
    print(2)

    tsda::db_writeTable2(token  = dms_token,table_name = 'rds_erp_src_t_CustomReceivables_input',r_object = data,append = TRUE)
    print(3)
    mdljhDomesticCustomCreditPkg::DomesticCustomCredit_Receive_insert(dms_token =dms_token )
    print(4)

    #获取债权
    data = mdljhDomesticCustomCreditPkg::DomesticCustomCredit_MATUREDDEBIT_view(erp_token = erp_token,FDate = FDate)
    print(5)
    tsda::db_writeTable2(token  = dms_token,table_name = 'rds_erp_src_t_AR_MATUREDDEBIT_input',r_object = data,append = TRUE)
    print(6)
    mdljhDomesticCustomCreditPkg::DomesticCustomCredit_MATUREDDEBIT_insert(dms_token = dms_token)
    print(7)
    #获取dms客户
    data = mdljhDomesticCustomCreditPkg::DomesticCustomCredit_customer_DMS_view(dms_token =dms_token,FDate = FDate)
    print(8)
    tsda::db_writeTable2(token  = erp_token,table_name = 'rds_src_t_customer_sum',r_object = data,append = TRUE)
    print(9)
    #获取erp客户
    print(10)
    data = mdljhDomesticCustomCreditPkg::DomesticCustomCredit_customer_ERP_view(erp_token = erp_token)
    print(11)

    tsda::db_writeTable2(token  = dms_token,table_name = 'rds_erp_src_t_customer',r_object = data,append = TRUE)

    data = mdljhDomesticCustomCreditPkg::DomesticCustomCredit_view(dms_token = dms_token)



    servenFDate= substr(FDate, 1, 7)

    tsui::run_dataTable2(id ='DomesticCustomCredit_resultView' ,data =data )

    filename = paste0("信用测算",servenFDate,".xlsx")
    tsui::run_download_xlsx(id = 'dl_DomesticCustomCredit',data = data,filename = filename)






  })





}



#' 处理逻辑
#'
#' @param input 输入
#' @param output 输出
#' @param session 会话
#' @param erp_token 口令
#'
#' @return 返回值
#' @export
#'
#' @examples
#' DomesticCustomCreditServer()
DomesticCustomCreditServer <- function(input,output,session,dms_token,erp_token) {

  DomesticCustomCreditViewServer(input = input,output = output,session=session,dms_token= dms_token,erp_token=erp_token)
}









