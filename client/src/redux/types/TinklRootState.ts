import { UserType } from "./UserType";
import { BathroomType } from "./BathroomType";
import { TinklOptions } from "./TinklOptions";
import { BathroomFilters } from "./BathroomFilters";
import { SearchedLocation } from "./SearchedLocation";

export interface TinklRootState {
    bathroomData: BathroomType[],
    user: UserType,
    options: TinklOptions,
    filters: BathroomFilters,
    searchedLocation: SearchedLocation
}