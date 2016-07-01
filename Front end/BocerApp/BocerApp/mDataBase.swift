//
//  mDataBase.swift
//  BocerApp
//
//  Created by Dempsy on 6/30/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import Foundation

class mDataBase {
   
    private var db: COpaquePointer = nil
    
    ///  打开数据库  是否打开成功
    func openDatabase() -> Bool {
        
        let doc = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let dbname = "BocerApp-local.db"
        let path = doc.first! + "/" + dbname
        
        let fm = NSFileManager.defaultManager()
        
        let find = fm.fileExistsAtPath(path)
        
        print("find = \(find) path = \(path)")
        
        // 如果数据库存在，则用sqlite3_open直接打开（不要担心，如果数据库不存在sqlite3_open会自动创建）
        // sqlite3_open 如果如果数据库不存在，会新建数据库文件
        // 如果数据库文件已经存在，就直接打开，返回句柄，不会对数据有任何影响
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("打开数据库成功")
            // 本质上只需要运行一次就可以了
            if createTable() {
                print("创表成功")
                // TODO: 测试查询数据
                //let sql = "SELECT id, DepartmentNo, Name FROM T_Department;"
                //recordSet(sql)
            } else {
                print("创表失败")
            }
            return true
        } else {
            print("打开数据库失败")
            sqlite3_close(db)
            return false
        }
    }
    ///  创建数据表，将系统需要的数据表，一次性创建
    private func createTable() -> Bool {
        // 准备所有数据表的 SQL
        // 1> 每一个 SQL 完成后都有一个 ;
        // 2> 将所有创表 SQL 写在一起，每一个换行添加一个 \n
        let sql = "CREATE TABLE \n" +
            "IF NOT EXISTS User (\n" +
            "userName VARCHAR(255) PRIMARY KEY,\n" +
            "password VARCHAR(255) NOT NULL); \n\n" +
            "CREATE TABLE IF NOT EXISTS Profile ( \n" +
            "userName VARCHAR(255) PRIMARY KEY, \n" +
            "firstName VARCHAR(255) NOT NULL, \n" +
            "lastName VARCHAR(255) NOT NULL, \n" +
            "profileImageSmall VARCHAR(1000), \n" +
            "profileImageLarge VARCHAR(1000), \n" +
            "FOREIGN KEY (userName) REFERENCES User (userName) ON DELETE RESTRICT ON \n" +
        "UPDATE CASCADE);"
        
        var stmt:COpaquePointer = nil
        
        //sqlite3_prepare_v2 接口把一条SQL语句解析到statement结构里去. 使用该接口访问数据库是当前比较好的的一种方法
        //第一个参数跟前面一样，是个sqlite3 * 类型变量，
        //第二个参数是一个 sql 语句。
        //第三个参数我写的是-1，这个参数含义是前面 sql 语句的长度。如果小于0，sqlite会自动计算它的长度（把sql语句当成以\0结尾的字符串）。
        //第四个参数是sqlite3_stmt 的指针的指针。解析以后的sql语句就放在这个结构里。
        //第五个参数是错误信息提示，一般不用,为nil就可以了。
        //如果这个函数执行成功（返回值是 SQLITE_OK 且 statement 不为NULL ），那么下面就可以开始插入二进制数据。
        let sqlReturn = sqlite3_prepare_v2(db, sql, -1, &stmt, nil);
        
        
        //如果SQL语句解析出错的话程序返回
        if(sqlReturn != SQLITE_OK) {
            return false;
        }
        
        //执行SQL语句
        let success = sqlite3_step(stmt);
        //释放sqlite3_stmt
        sqlite3_finalize(stmt);
        
        //执行SQL语句失败
        if ( success != SQLITE_DONE) {
            return false
        }
        return true
        
    }
    
    ///  执行没有返回值的 SQL 语句
    ///
    ///  :param: sql SQL 字符串
    ///
    ///  :returns: 是否成功
    func execSQL(sql: String) -> Bool {
        /**
         1. 数据库指针
         2. SQL 字符串的 C 语言格式
         3. 回调，执行完成 SQL 指令之后的函数回调，通常都是 nil
         4. 回调的第一个参数的指针
         5. 错误信息，通常也传入 nil
         */
        return sqlite3_exec(db, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, nil, nil, nil) == SQLITE_OK
    }
    
    func insertTab() -> Bool {
        if self.openDatabase(){
            //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
            var sql = "inser () values(?,?,?)"
            sql = "update table set a=?,b=? where id =?"
            sql = "delete from tab where 1=1 "
            // 1. 准备语句
            var stmt: COpaquePointer = nil
            
            /**
             1. 数据库句柄
             2. SQL 的 C 语言的字符串
             3. SQL 的 C 语言的字符串长度 strlen，-1 会自动计算
             4. stmt 的指针
             5. 通常传入 nil
             */
            var suc = sqlite3_prepare_v2(db, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &stmt, nil)
            
            if suc == SQLITE_OK {
                
                
                //                let intTran = UnsafeMutablePointer<Int>(bitPattern: -1)
                //                let tranPointer = COpaquePointer(intTran)
                //                let transient = CFunctionPointer<((UnsafeMutablePointer<()>) -> Void)>(tranPointer)
                
                //http://stackoverflow.com/questions/26883131/sqlite-transient-undefined-in-swift/26884081#26884081
                let SQLITE_STATIC = unsafeBitCast(0, sqlite3_destructor_type.self)
                let SQLITE_TRANSIENT = unsafeBitCast(-1, sqlite3_destructor_type.self)
                
                //索引从1开始   这里的数字1，2，3代表上面的第几个问号，这里将三个值绑定到三个绑定变量
                sqlite3_bind_int(stmt, 1, 123);
                sqlite3_bind_text(stmt, 2, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(stmt, 3, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, SQLITE_TRANSIENT)
                
                //执行 语句
                suc = sqlite3_step(stmt)
                
                //释放statement
                sqlite3_finalize(stmt)
                
                //关闭数据库
                sqlite3_close(db)
                
                if suc == SQLITE_ERROR{
                    return false
                }else{
                    return true
                }
            }else{
                
                if let error = String.fromCString(sqlite3_errmsg(self.db)) {
                    let msg = "SQLiteDB - failed to prepare SQL: \(sql), Error: \(error)"
                    print(msg)
                }
                sqlite3_finalize(stmt)
                sqlite3_close(db)
                return false
            }
        }
        return false
        
    }
    
    ///  执行 SQL 返回一个结果集(对象数组)
    ///
    ///  :param: sql SQL 字符串
    func recordSet(sql: String) {
        // 1. 准备语句
        var stmt: COpaquePointer = nil
        /**
         1. 数据库句柄
         2. SQL 的 C 语言的字符串
         3. SQL 的 C 语言的字符串长度 strlen，-1 会自动计算
         4. stmt 的指针
         5. 通常传入 nil
         */
        if sqlite3_prepare_v2(db, sql.cStringUsingEncoding(NSUTF8StringEncoding)!, -1, &stmt, nil) == SQLITE_OK {
            // 单步获取SQL执行的结果 -> sqlite3_setup 对应一条记录
            //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
            while sqlite3_step(stmt) == SQLITE_ROW {
                // 获取每一条记录的数据
                recordData(stmt)
            }
        }
        sqlite3_finalize(stmt)
        sqlite3_close(db)
    }
    ///  获取每一条数据的记录
    ///
    ///  :param: stmt prepared_statement 对象
    func recordData(stmt: COpaquePointer) {
        // 获取到记录
        let count = sqlite3_column_count(stmt)
        print("获取到记录，共有多少列 \(count) ")
        // 遍历每一列的数据
        for i in 0..<count {
            let type = sqlite3_column_type(stmt, i)
            // 根据字段的类型，提取对应列的值
            switch type {
            case SQLITE_INTEGER:
                print("整数 \(sqlite3_column_int64(stmt, i))")
            case SQLITE_FLOAT:
                print("小树 \(sqlite3_column_double(stmt, i))")
            case SQLITE_NULL:
                print("空 \(NSNull())")
            case SQLITE_TEXT:
                let chars = UnsafePointer<CChar>(sqlite3_column_text(stmt, i))
                let str = String(CString: chars, encoding: NSUTF8StringEncoding)!
                print("字符串 \(str)")
            case let type:
                print("不支持的类型 \(type)")
            }
        }
    }
    
}