
declare namespace API {
    namespace SignIn {
        export interface Request {
            username: string;
            password: string;
        }
        export interface Response {
            message: string;
            errorCode: number;
        }
    }
    namespace SignUp {
        export interface Request {
            username: string;
            password: string;
        }
        export interface Response {
            message: string;
            errorCode: number;
        }
    }
}