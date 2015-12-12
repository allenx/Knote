//
//  editPanelViewController.m
//  Knote
//
//  Created by Allen X on 11/1/15.
//  Copyright © 2015 Allen X. All rights reserved.
//

#import "editPanelViewController.h"
#import "mainPanelViewController.h"

@interface editPanelViewController ()
@property (strong, nonatomic) IBOutlet UITextField *noteName;
@property (strong, nonatomic) IBOutlet UITextView *editArea;

@end

@implementation editPanelViewController
@synthesize editArea;
@synthesize noteName;
@synthesize dataBase;
@synthesize editStatus;

- (void)viewDidLoad {
    NSLog(@"into edit");
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self openSQLite];
    [self createDatabase];

    self.noteName.text = self.detailName;
    self.editArea.text = self.detailText;
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSString *)findDocuments
{
    NSArray *document_path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [document_path objectAtIndex:0];
    return path;
}

- (void)openSQLite
{
    NSString *path = [self findDocuments];
    dbPath = [[NSString alloc] initWithString:[path stringByAppendingPathComponent:@"axKnotes.db"]];
    int result = sqlite3_open([dbPath UTF8String], &dataBase);
    if(result == SQLITE_OK)
    {
        NSLog(@"open success:result is %d",result);
    }
}

- (int)execSQL:(NSString *)sql
{
    char *errmsg;
    int result = sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &errmsg);
    return result;
}

- (void)createDatabase
{
    NSString *createsql = @"CREATE TABLE IF NOT EXISTS axKnotes (ID INTEGER PRIMARY KEY AUTOINCREMENT, CONTENT TEXT)";
    int result = [self execSQL:createsql];
    if (result == SQLITE_OK)
    {
        NSLog(@"createTable SUCCESS,result is %d",result);
    }
}

- (void)dismissKeyboard {
    [self.editArea resignFirstResponder];
    [self.noteName resignFirstResponder];
}

- (BOOL)textFieldShouldReturn: (UITextField *)content {
    if(content == self.noteName){
        [self.editArea becomeFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelNote:(id)sender {
}

- (void) updateObject{
    if(sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK){
        NSString *sql = [[NSString alloc] initWithFormat:@"UPDATE axKnotes SET NOTESNAME = '%@', NOTESCONTENT = '%@' WHERE NOTESCONTENT = '%@'", self.noteName.text, self.editArea.text, self.detailText];
        //NSLog(sql);
        int result = [self execSQL:sql];
        if(result == SQLITE_OK){
            NSLog(@"Update succeeded");
        }
    }
    sqlite3_close(dataBase);
}

- (void) createNewObject{
    //解决输入单引号的问题
    /*NSString *str = editArea.text;
    const char *sql = "INSERT INTO axKnotes(NOTESNAME, NOTESCONTENT, STATUS) VALUES()";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(dataBase, sql, -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [str UTF8String], -1, SQLITE_TRANSIENT);
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSLog(@"SQL execution failed: %s", sqlite3_errmsg(dataBase));
        }
    }
    else {
        NSLog(@"SQL prepare failed: %s", sqlite3_errmsg(dataBase));
    }
    sqlite3_finalize(stmt);*/
    
    NSString *sql  = [[NSString alloc] initWithFormat:@"INSERT INTO axKnotes (NOTESNAME, NOTESCONTENT, STATUS) VALUES( '%@', '%@', '%@')", self.noteName.text, self.editArea.text, @"Normal"];
    
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK) {
        int result = [self execSQL:sql];
        if (result != SQLITE_OK) {
            NSLog(@"Insert failed, %d", result);
        }
    }
    sqlite3_close(dataBase);
}


- (IBAction)saveNote:(id)sender {

    if (editStatus == YES) {
        [self updateObject];
    }
    else {
        [self createNewObject];
    }
}
@end
