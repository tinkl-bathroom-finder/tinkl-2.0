import { UserType } from "./UserType";
import { BathroomType } from "./BathroomType";
import { TinklOptions } from "./TinklOptions";

export interface TinklRootState {
    bathroomData: BathroomType,
    user: UserType,
    options: TinklOptions
}