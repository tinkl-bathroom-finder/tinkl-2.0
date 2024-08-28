import { UserType } from "./UserType";
import { BathroomType } from "./BathroomType";

export interface TinklRootState {
    bathroomData: BathroomType,
    user: UserType
}