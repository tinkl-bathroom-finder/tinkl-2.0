import axios from "axios"

export const sendBathroomLike = async (user_id: number, bathroom_id: number, vote: string): Promise<void> => {
    try {
        const api = import.meta.env.VITE_API_BASE_URL || "https://transphasic.asuscomm.com";
        const data = { user_id, bathroom_id, vote };

        await axios.post(`${api}/api/feedback/like`, data);
    } catch (error) {
        console.error("Error sending bathroom like:", error);
        throw error;
    }
};