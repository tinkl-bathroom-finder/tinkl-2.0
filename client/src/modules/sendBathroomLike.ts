import axios from "axios";

//Types
import { LikeBathroomType } from '../../../server/src/types/FeedbackTypes';
import { UpdateLikesType } from "../redux/types/FeedbackTypes";

export const sendBathroomLike = async (user_id: number, bathroom_id: number, vote: string): Promise<UpdateLikesType> => {
    const api = import.meta.env.VITE_API_BASE_URL || 'https://transphasic.asuscomm.com';
    try {
        const api = import.meta.env.VITE_API_BASE_URL || "https://transphasic.asuscomm.com";
        const data: LikeBathroomType = { user_id, bathroom_id, vote };
        await axios.post(`${api}/api/feedback/like`, data, { withCredentials: true });
        const results = await axios.get(`${api}/api/bathrooms/getUpdatedLikes/?restroom_id=${bathroom_id}`);
        console.log('Results.data', results.data);
        const returnData: UpdateLikesType = {
            bathroom_id: bathroom_id,
            upVotes: results.data[0].upvotes,
            downVotes: results.data[0].downvotes,
            vote: vote
        }
        return returnData;

    } catch (error) {
        console.error("Error sending bathroom like:", error);
        throw error;
    }
};