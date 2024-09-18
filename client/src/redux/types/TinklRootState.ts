import { UserType } from "./UserType";
import { BathroomType } from "./BathroomType";
import { TinklOptions } from "./TinklOptions";
import { BathroomFilters } from "./BathroomFilters";

export interface TinklRootState {
    bathroomData: BathroomType[],
    user: UserType,
    options: TinklOptions,
    filters: BathroomFilters,
}