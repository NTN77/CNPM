package model.bean;

import org.jdbi.v3.core.mapper.reflect.ColumnName;

public class Tip {
    private String title ;
    private String description ;


    private String imgPath ;
    @ColumnName("video_link")
    private String videoLink ;

    public Tip(){

    }

    public Tip(String title, String description, String imgPath, String videoLink) {
        this.title = title;
        this.description = description;
        this.imgPath = imgPath;
        this.videoLink = videoLink;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImgPath() {
        return imgPath;
    }

    public void setImgPath(String imgPath) {
        this.imgPath = imgPath;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    @Override
    public String toString() {
        return "Tip{" +
                "title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", img_path='" + imgPath + '\'' +
                ", video_link='" + videoLink + '\'' +
                '}';
    }
}