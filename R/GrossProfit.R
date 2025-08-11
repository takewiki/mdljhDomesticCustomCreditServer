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
#' GrossProfitViewServer()
GrossProfitViewServer <- function(input,output,session,dms_token,erp_token) {
  text_flie_GrossProfit = tsui::var_file('text_flie_GrossProfit')
  text_date_GrossProfit_FDate =tsui::var_date('text_date_GrossProfit_FDate')

  text_date_GrossProfit_FDate_bak =tsui::var_date('text_date_GrossProfit_FDate_bak')

  shiny::observeEvent(input$btn_GrossProfit_Up,{
    if(is.null(text_flie_GrossProfit())){

      tsui::pop_notice('请先上传文件')
    }
    else{
      filename=text_flie_GrossProfit()
      data <- readxl::read_excel(filename,
                                 col_types = c("numeric", "numeric", "date",
                                               "text", "text", "text", "text", "numeric",
                                               "numeric", "numeric"))


      data = as.data.frame(data)

      data = tsdo::na_standard(data)


      tsda::db_writeTable2(token  = dms_token,table_name = 'rds_dms_src_t_GrossProfit_input',r_object = data,append = TRUE)

      mdljhDomesticCustomCreditPkg::GrossProfit_upload(dms_token =dms_token )

      tsui::pop_notice('上传成功')



    }

  })
#查询当前记录
  shiny::observeEvent(input$btn_GrossProfit_view,{

    FDate =text_date_GrossProfit_FDate()
    servenFDate= substr(FDate, 1, 7)

    data = mdljhDomesticCustomCreditPkg::GrossProfit_new_view(dms_token =dms_token,FDate = FDate)

    tsui::run_dataTable2(id ='GrossProfit_resultView' ,data =data )

    filename = paste0("当前毛利表",servenFDate,"的近六月数据.xlsx")
    tsui::run_download_xlsx(id = 'dl_GrossProfit',data = data,filename = filename)



  })
  #查询存档记录
  shiny::observeEvent(input$text_date_GrossProfit_FDate_bak,{


    FDate =text_date_GrossProfit_FDate()
    servenFDate= substr(FDate, 1, 7)

    data = mdljhDomesticCustomCreditPkg::GrossProfit_archive_view(dms_token =dms_token,FDate = FDate)

    tsui::run_dataTable2(id ='GrossProfit_resultView' ,data =data )

    filename = paste0("毛利表",servenFDate,"存档的近六月数据.xlsx")
    tsui::run_download_xlsx(id = 'dl_GrossProfit',data = data,filename = filename)


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
#' GrossProfitServer()
GrossProfitServer <- function(input,output,session,dms_token,erp_token) {

  GrossProfitViewServer(input = input,output = output,session=session,dms_token= dms_token,erp_token=erp_token)
}









