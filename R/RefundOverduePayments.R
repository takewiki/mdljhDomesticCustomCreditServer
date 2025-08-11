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
#' RefundOverduePaymentsViewServer()
RefundOverduePaymentsViewServer <- function(input,output,session,dms_token,erp_token) {
  text_flie_RefundOverduePayments = tsui::var_file('text_flie_RefundOverduePayments')
  text_date_RefundOverduePayments_FDate =tsui::var_date('text_date_RefundOverduePayments_FDate')

  text_date_RefundOverduePayments_FDate_bak =tsui::var_date('text_date_RefundOverduePayments_FDate_bak')

  shiny::observeEvent(input$btn_RefundOverduePayments_Up,{
    if(is.null(text_flie_RefundOverduePayments())    ){

      tsui::pop_notice('请先上传文件')
    }else if(is.null(text_flie_RefundOverduePayments())    ){

      tsui::pop_notice('请输入会计所属期')
    }
    else{
      filename=text_flie_RefundOverduePayments()
      data <- readxl::read_excel(filename,
                                 col_types = c("text", "numeric", "text",
                                               "text", "text", "text", "numeric",
                                               "numeric", "numeric", "text", "text",
                                               "numeric", "text"))


      data = as.data.frame(data)

      data = tsdo::na_standard(data)


      tsda::db_writeTable2(token  = dms_token,table_name = 'rds_dms_src_t_RefundOverduePayments_input',r_object = data,append = TRUE)

      FDate=text_date_RefundOverduePayments_FDate()

      mdljhDomesticCustomCreditPkg::RefundOverduePayments_upload(dms_token = dms_token,FDate = FDate)

      tsui::pop_notice('上传成功')



    }

  })
  #查询当前记录
  shiny::observeEvent(input$btn_RefundOverduePayments_view,{


    data = mdljhDomesticCustomCreditPkg::RefundOverduePayments_new_view(dms_token =dms_token)

    tsui::run_dataTable2(id ='RefundOverduePayments_resultView' ,data =data )

    tsui::run_download_xlsx(id = 'dl_RefundOverduePayments_new',data = data,filename = "当前逾期表数据.xlsx")



  })
  #查询存档记录
  shiny::observeEvent(input$text_date_RefundOverduePayments_FDate_bak,{


    FDate =text_date_RefundOverduePayments_FDate_bak()
    servenFDate= substr(FDate, 1, 7)

    data = mdljhDomesticCustomCreditPkg::RefundOverduePayments_archive_view(dms_token =dms_token,FDate = FDate)

    tsui::run_dataTable2(id ='RefundOverduePayments_resultView' ,data =data )

    filename = paste0("逾期表会计所属期为",servenFDate,"的数据.xlsx")
    tsui::run_download_xlsx(id = 'dl_RefundOverduePayments_bak',data = data,filename = filename)


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
#' RefundOverduePaymentsServer()
RefundOverduePaymentsServer <- function(input,output,session,dms_token,erp_token) {

  RefundOverduePaymentsViewServer(input = input,output = output,session=session,dms_token= dms_token,erp_token=erp_token)
}









